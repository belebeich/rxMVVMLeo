//
//  TodayViewController.swift
//  rxMVVMLeoToday
//
//  Created by Ivan  on 25/05/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import NotificationCenter

class TodayViewController: NSViewController {
  
  @IBOutlet weak private var alreadyLabel: NSTextField!
  @IBOutlet weak private var translateSegmentControl: NSSegmentedControl!
  @IBOutlet weak private var translateScrollView: NSScrollView!
  @IBOutlet weak private var translateTableView: CustomNSTableView!
  @IBOutlet weak private var availableWordsLabel: NSTextField!
  @IBOutlet weak private var searchIndicator: NSProgressIndicator!
  @IBOutlet weak private var wordTextView: NSTextField!
  @IBOutlet weak private var addWordButton: NSButton!
  
  private let bag = DisposeBag()
  private var translates = [String]()
  private var previousHeight = CGFloat.init(1000.0)
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("TodayViewController")
  }
  
  override func viewDidLoad() {
    translateTableView.delegate = self
    translateTableView.dataSource = self
    
    setConstraints()
    setUI()
    bindUI()
  }
  
  private func bindUI() {
    let viewModel = TranslateViewModel.init(word: wordTextView.rx.text.orEmpty.asDriver())
    
    switch LeoAPI.shared.state.value {
    case .unavailable:
      addWordButton.isEnabled = false
      wordTextView.isEnabled = false
      addWordButton.isHidden = true
      translateSegmentControl.isEnabled = false
      let _ = Observable.of("Please login through main app")
        .bind(to: self.wordTextView.rx.text)
        .disposed(by: bag)
    case .success(_):
      wordTextView.isEnabled = true
      let _ = Observable.of("")
        .bind(to: self.wordTextView.rx.text)
        .disposed(by: bag)
    }
    
    viewModel.segment
      .take(1)
      .bind(to: translateSegmentControl.rx.selectedSegmentIndex)
      .disposed(by: bag)
    
    let translateResults = Observable.combineLatest(wordTextView.rx.text.orEmpty, translateSegmentControl.rx.selectedSegmentIndex)
      .throttle(0.3, scheduler: MainScheduler.instance)
      .skip(1)
      .flatMapLatest { [unowned self] query, index -> Observable<[String]> in
        self.enableSegments()
        if query.isEmpty {
          self.addWordButton.isEnabled = false
          return .just([])
        } else {
          self.alreadyLabel.isHidden = true
          self.searchIndicator.isHidden = false
          self.searchIndicator.startAnimation(self)
          let enabled = self.translateSegmentControl.isSelected(forSegment: index)
          self.translateSegmentControl.setEnabled(!enabled, forSegment: index)
          return viewModel.translate(word: query, translateAPI: index)
        }
      }
      .do(onNext: { [unowned self] _ in
        self.searchIndicator.stopAnimation(self)
        self.searchIndicator.isHidden = true
      })
      .observeOn(MainScheduler.instance)
    
    translateResults
      .subscribe(onNext: { [unowned self] words in
        self.translates = words
        self.translateTableView.reloadData()
        if self.previousHeight >= self.translateTableView.frame.size.height {
          self.setUI()
        }
        self.previousHeight = self.translateTableView.frame.size.height
      })
      .disposed(by: bag)
    
    viewModel.setTranslateOptions(with: translateSegmentControl.rx.value.asDriver())
    
    translateSegmentControl.rx.value.asObservable()
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] _ in
        self.addWordButton.isEnabled = false
      })
      .disposed(by: bag)
    
    addWordButton.rx.tap
      .flatMap { [unowned self] _ -> Observable<AddWord> in
        return viewModel.add(word: self.wordTextView.stringValue, translate: self.translates[self.translateTableView.selectedRow])
      }
      .subscribe(onNext: { [unowned self] response in
        switch response {
        case .error:
          self.alreadyLabel.stringValue = "Error"
          self.alreadyLabel.isHidden = false
        case .success(let new):
          self.alreadyLabel.isHidden = new
          self.addWordButton.isEnabled = false
          viewModel.meatballs()
            .bind(to: self.availableWordsLabel.rx.text)
            .disposed(by: self.bag)
        }
      })
      .disposed(by: bag)
    
    viewModel.meatballs()
      .bind(to: availableWordsLabel.rx.text)
      .disposed(by: bag)
  }
}

//MARK: - UI
private extension TodayViewController {
  
  func enableSegments() {
    let count = translateSegmentControl.segmentCount - 1
    for index in 0...count {
      translateSegmentControl.setEnabled(true, forSegment: index)
    }
  }
  
  func setConstraints() {
    let height = NSLayoutConstraint(item: translateScrollView, attribute: .height, relatedBy: .equal, toItem: translateTableView, attribute: .height, multiplier: 1, constant: 0)
    view.addConstraint(height)
  }
  
  func setUI() {
    translateTableView.sizeToFit()
    let height = translateTableView.fittingSize.height
    translateScrollView.setFrameSize(CGSize(width: translateScrollView.frame.size.width, height: height))
    translateScrollView.autoresizesSubviews = true
  }
}

//MARK: - NSTableViewDataSource
extension TodayViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    if self.translates.count > 5 {
      return 5
    } else {
      return self.translates.count
    }
  }
}

//MARK: - NSTableViewDelegate
extension TodayViewController: NSTableViewDelegate {
  
  func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    let height = calculateHeight(for: row, at: tableView)
    return height
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "translateTableViewCell"), owner: nil) as? NSTableCellView {
      if !self.translates.isEmpty {
        if !self.translates[row].isEmpty {
          cell.textField?.stringValue = self.translates[row]
          cell.textField?.lineBreakMode = .byWordWrapping
          cell.textField?.usesSingleLineMode = false
          cell.textField?.cell?.wraps = true
          cell.textField?.translatesAutoresizingMaskIntoConstraints = false
          cell.textField?.layoutSubtreeIfNeeded()
          cell.textField?.needsUpdateConstraints = true
          setUI()
        }
      }
      return cell
    }
    return nil
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    addWordButton.isEnabled = true
  }
  
  func calculateHeight(for row: Int, at tableView: NSTableView) -> CGFloat {
    let text = translates[row]
    let textField = NSTextField.init()
    textField.lineBreakMode = .byWordWrapping
    textField.usesSingleLineMode = false
    textField.cell?.wraps = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = NSFont(name: "System Regular", size: 24)
    textField.frame.size.width = tableView.bounds.size.width
    textField.preferredMaxLayoutWidth = textField.frame.size.width
    textField.needsLayout = true
    textField.attributedStringValue  = NSAttributedString(string: text)
    textField.sizeToFit()
    textField.isEditable = false
    textField.updateConstraintsForSubtreeIfNeeded()
    textField.layoutSubtreeIfNeeded()
    textField.needsUpdateConstraints = true
    return textField.fittingSize.height + 10
  }
}

