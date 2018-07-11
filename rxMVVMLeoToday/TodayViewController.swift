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

    
    @IBOutlet weak var searchIndicator: NSProgressIndicator!
    @IBOutlet var wordTextView: NSTextField!
    @IBOutlet var translateTextView: NSTextView!
    @IBOutlet weak var addWordButton: NSButton!
    
    let bag = DisposeBag()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad() {
        
        setUI()
        bindUI()
    }
    
    
    
    func bindUI() {
        let viewModel = TranslateViewModel.init(word: wordTextView.rx.text.orEmpty.asDriver())
        print(LeoAPI.shared.state.value)
        switch LeoAPI.shared.state.value {
        case .unavailable:

            self.addWordButton.isEnabled = false
            self.wordTextView.isEnabled = false
            let text = Observable.of("Please login through main app")
            text
                .bind(to: self.wordTextView.rx.text)
                .disposed(by: bag)
            
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
            .flatMapLatest { query -> Observable<String> in
                
                if query.isEmpty {
                    self.addWordButton.isEnabled = false
                    
                    return .just("")
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
            .bind(to: translateTextView.rx.text)
            .disposed(by: bag)
        
        addWordButton.rx.tap
            .subscribe(onNext: {
                viewModel.add(word: self.wordTextView.stringValue, translate: self.translateTextView.string)
                print("yeap")
            })
            .disposed(by: bag)
    }
    
    func setUI() {

    }

    

}
