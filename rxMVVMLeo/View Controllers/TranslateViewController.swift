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
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                print("sds")
                viewModel.logout()
                print(LeoAPI.shared.state.value)
            })
            .disposed(by: bag)
    }
    
}
