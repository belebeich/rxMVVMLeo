//
//  TranslateViewController.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 07/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class TranslateViewController: NSViewController {
    
    let bag = DisposeBag()

    @IBOutlet weak var wordTextField: NSTextField!
    @IBOutlet weak var translateTextField: NSTextField!
    @IBOutlet weak var logoutButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bindUI()
    }
    
    func bindUI() {
        let viewModel = TranslateViewModel.init(word: wordTextField.rx.text.orEmpty.asDriver())
        
        let translateResults = wordTextField.rx.text.orEmpty
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
            .bind(to: translateTextField.rx.text)
            .disposed(by: bag)
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                print("sds")
                viewModel.logout()
                print(LeoAPI.shared.state.value)
            })
            .disposed(by: bag)
    }
    
}
