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

class MainViewController: NSViewController {
    
    let bag = DisposeBag()

    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var logoutButton: NSButton!
    @IBOutlet weak var helpButton: NSButton!
    @IBOutlet weak var accountButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    override func viewWillLayout() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [NSColor.init(calibratedRed: 202/255, green: 196/255, blue: 187/255, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor]
        gradientLayer.frame = self.view.bounds
        self.view.layer?.insertSublayer(gradientLayer, at: 0)
        
        self.view.wantsLayer = true
    }

    
    func bindUI() {
        
        accountButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tabView.selectTabViewItem(at: 0)
            })
            .disposed(by: bag)
        
        helpButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tabView.selectTabViewItem(at: 1)
            })
            .disposed(by: bag)
        
//        let viewModel = TranslateViewModel.init(word: wordTextField.rx.text.orEmpty.asDriver())
//        self.addWordButton.isEnabled = false
//        let translateResults = wordTextField.rx.text.orEmpty
//            .throttle(0.3, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { query -> Observable<[String]> in
//                if query.isEmpty {
//                    self.addWordButton.isEnabled = false
//                    return .just([])
//                } else {
//                    self.addWordButton.isEnabled = true
//                    self.searchIndicator.isHidden = false
//                    self.searchIndicator.startAnimation(self)
//                    return viewModel.translate(word: query, translateAPI: 0)
//                }
//            }
//            .do(onNext: { _ in
//                self.searchIndicator.stopAnimation(self)
//                self.searchIndicator.isHidden = true
//            })
//            .observeOn(MainScheduler.instance)
//        
//        
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
        
//        logoutButton.rx.tap
//            .subscribe(onNext: {
//                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("logoutSegue"), sender: self)
//                viewModel.logout()
//            })
//            .disposed(by: bag)
//
//        viewModel.meatballs()
//            .bind(to: availableWordsLabel.rx.text)
//            .disposed(by: bag)
//
    
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.view.window?.close()
    }
    
}
