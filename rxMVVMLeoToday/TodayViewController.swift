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

    
    @IBOutlet var wordTextView: NSTextField!
    @IBOutlet var translateTextView: NSTextView!
    @IBOutlet weak var addWordButton: NSButton!
    
    let bag = DisposeBag()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad() {
        
        
//        let cookie = HTTPCookieStorage.shared.cookies(for: URL(string: "http://api.lingualeo.com")! )
//        for cook in cookie! {
//            print(cook)
//        }
        setUI()
        bindUI()
    }
    
    
    
    func bindUI() {
        let viewModel = TranslateViewModel.init(word: wordTextView.rx.text.orEmpty.asDriver())
//        print(LeoAPI.shared.state.value)
//        switch LeoAPI.shared.state.value {
//        case .unavailable:
//
//
//            self.wordTextView.isEnabled = false
//            let text = Observable.of("Please login through main app")
//            text
//                .bind(to: self.wordTextView.rx.text)
//                .disposed(by: bag)
//        case .success(_):
//
//            self.wordTextView.isEnabled = true
//            let text = Observable.of("")
//            text
//                .bind(to: self.wordTextView.rx.text)
//                .disposed(by: bag)
//        }
        
        let translateResults = wordTextView.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<String> in
                
                if query.isEmpty {
                    return .just("")
                } else {
                    return viewModel.translate(word: query)
                }
            }
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
