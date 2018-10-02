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

    @IBOutlet weak var searchIndicator: NSProgressIndicator!
    @IBOutlet weak var addWordButton: NSButton!
    @IBOutlet weak var availableWordsLabel: NSTextField!
    @IBOutlet weak var wordTextField: NSTextField!
    @IBOutlet weak var translateTextField: NSTextView!
    @IBOutlet weak var logoutButton: NSButton!
    @IBOutlet weak var backgroundNSBox: NSBox!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    func bindUI() {
        let viewModel = TranslateViewModel.init(word: wordTextField.rx.text.orEmpty.asDriver())
        self.addWordButton.isEnabled = false
        let translateResults = wordTextField.rx.text.orEmpty
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
                    return viewModel.translate(word: query, translateAPI: 0)
                }
            }
            .do(onNext: { _ in
                self.searchIndicator.stopAnimation(self)
                self.searchIndicator.isHidden = true
            })
            .observeOn(MainScheduler.instance)
        
        
//        translateResults
//            .bind(to: translateTextField.rx.text)
//            .disposed(by: bag)
        
        
        
//        addWordButton.rx.tap
//            .subscribe({ [unowned self] _ in
//                
//                viewModel.add(word: self.wordTextField.stringValue, translate: self.translateTextField.string)
//                    .map { result in
//                        if result == true {
//                            viewModel.meatballs()
//                                .bind(to: self.availableWordsLabel.rx.text)
//                                .disposed(by: self.bag)
//                        }
//                        return result
//                    }
//                    .asDriver(onErrorJustReturn: false)
//                    .drive(self.addWordButton.rx.isEnabled)
//                    .disposed(by: self.bag)
//                
//                
//            })
//            .disposed(by: bag)
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("logoutSegue"), sender: self)
                viewModel.logout()
            })
            .disposed(by: bag)
        
        viewModel.meatballs()
            .bind(to: availableWordsLabel.rx.text)
            .disposed(by: bag)
        
    
    }
    
    func setUI() {
        let fillColor = NSColor(red: 0.04313725, green: 0.43137255, blue: 0.21960784, alpha: CGFloat(0.9))
        self.backgroundNSBox.fillColor = fillColor
        self.translateTextField.backgroundColor = fillColor
        self.wordTextField.backgroundColor = fillColor
        self.translateTextField.textColor = NSColor.white
        self.translateTextField.backgroundColor = fillColor
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.view.window?.close()
    }
    
}
