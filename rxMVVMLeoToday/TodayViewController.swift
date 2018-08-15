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



class TodayViewController: NSViewController, NCWidgetProviding {

    
    
    @IBOutlet weak var translateScrollView: NSScrollView!
    @IBOutlet internal var translateTableView: CustomNSTableView!
    @IBOutlet weak var availableWordsLabel: NSTextField!
    @IBOutlet weak var searchIndicator: NSProgressIndicator!
    @IBOutlet var wordTextView: NSTextField!
    
    @IBOutlet weak var addWordButton: NSButton!
    
    let bag = DisposeBag()
    var translates = [String]()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad() {
        translateTableView.delegate = self
        translateTableView.dataSource = self
        
        translateScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //updatePreferredContentSize()
        setUI()
        bindUI()
    }
    
    
    
    func bindUI() {
        let viewModel = TranslateViewModel.init(word: wordTextView.rx.text.orEmpty.asDriver())
        
        switch LeoAPI.shared.state.value {
        case .unavailable:

            self.addWordButton.isEnabled = false
            self.wordTextView.isEnabled = false

            let text = Observable.of("Please login through main app")
            text
                .bind(to: self.wordTextView.rx.text)
                .disposed(by: bag)


            self.addWordButton.isHidden = true

        case .success(_):

            self.wordTextView.isEnabled = true
            let text = Observable.of("")
            text
                .bind(to: self.wordTextView.rx.text)
                .disposed(by: bag)
        }
        
        
        
        
        
        let translateResults = wordTextView.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[String]> in
                
                if query.isEmpty {
                    self.addWordButton.isEnabled = false
                    
                    return .just([])
                } else {
                    
                    self.addWordButton.isEnabled = true
                    self.searchIndicator.isHidden = false
                    self.searchIndicator.startAnimation(self)
                    
                    return viewModel.translate(word: query)
                }
            }
            .do(onNext: { _ in
                self.searchIndicator.stopAnimation(self)
                self.searchIndicator.isHidden = true
            })
            .observeOn(MainScheduler.instance)
        
        
        translateResults
            .subscribe(onNext: { words in
                
                
                self.translates = words
                self.setUI()
                self.translateTableView.reloadData()
            })
            .disposed(by: bag)
        
        
        addWordButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                
                if !self.translates.isEmpty {
                    viewModel.add(word: self.wordTextView.stringValue, translate: self.translates[self.translateTableView.selectedRow])
                }
                
                
                viewModel.meatballs()
                    .bind(to: self.availableWordsLabel.rx.text)
                    .disposed(by: self.bag)
                self.addWordButton.isEnabled = false
                
            })
            .disposed(by: bag)
//        addWordButton.rx.tap
//            .subscribe(onNext: { [unowned self] in
//                viewModel.add(word: self.wordTextView.stringValue, translate: self.translateTextView.string)
//                viewModel.meatballs()
//                    .bind(to: self.availableWordsLabel.rx.text)
//                    .disposed(by: self.bag)
//
//                self.addWordButton.isEnabled = false
//
//            })
//            .disposed(by: bag)
        
        viewModel.meatballs()
            .bind(to: self.availableWordsLabel.rx.text)
            .disposed(by: self.bag)
        
    }
    
    func updatePreferredContentSize() {
        translateTableView.needsLayout = true
        translateTableView.layoutSubtreeIfNeeded()
        
        
        
        let height = translateTableView.fittingSize.height
        let width: CGFloat = 320
        
        preferredContentSize = CGSize(width: width, height: height)
        
        self.translateScrollView.frame.size = self.translateTableView.fittingSize
    }
    
    func setUI() {
        //translateTableView.needsLayout = true
        
        translateTableView.sizeToFit()
        let height = translateTableView.fittingSize.height
        let width: CGFloat = 320
        let size = NSSize(width: width, height: height)
        
        translateTableView.setFrameSize(size)
        
        //preferredContentSize = CGSize(width: width, height: height)
        
        //preferredContentSize = CGSize(width: width, height: height)
        
        //translateTableView.layoutSubtreeIfNeeded()
    }

}


extension TodayViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if self.translates.count > 5 {
            return 5
        } else {
            return self.translates.count
        }
    }
    
    
    
}

extension TodayViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
       
        let text = self.translates[row]
        let cell = NSTextField.init()
        
        
        cell.lineBreakMode = .byWordWrapping
        
        cell.usesSingleLineMode = false
        cell.cell?.wraps = true
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.font = NSFont(name: "System Regular", size: 24)
        
        cell.frame.size.width = tableView.bounds.size.width
        cell.preferredMaxLayoutWidth = cell.frame.size.width
        //
        cell.needsLayout = true
        
        cell.attributedStringValue  = NSAttributedString(string: text)
        cell.sizeToFit()
        
        cell.isEditable = false
        
        cell.updateConstraintsForSubtreeIfNeeded()
        cell.layoutSubtreeIfNeeded()
        cell.needsUpdateConstraints = true
        
        //print(cell.fittingSize.height)
        
        return cell.fittingSize.height + 10
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "translateTableViewCell"), owner: nil) as? NSTableCellView {
            if !self.translates.isEmpty {
                if !self.translates[row].isEmpty {
                    cell.textField?.stringValue = self.translates[row]
                    setUI()
                    
                }
            }
            
            return cell
        }
        return nil
    }
}



