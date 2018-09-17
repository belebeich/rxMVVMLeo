//
//  ViewController.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class LoginViewController: NSViewController {
    
    
    let bag = DisposeBag()
    
    @IBOutlet weak var loginInfoStack: NSStackView!
    @IBOutlet var tesy: NSTextView!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var tokenLabel: NSTextField!
    
    @IBOutlet weak var logoutButton: NSButton!
    
    override func viewDidAppear() {
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setUI() {
        loginInfoStack.animator().alphaValue = 0.0
        
        
        let test = self.tesy.setTextWithTypeAnimation(typedText: "It's a demo MacOS Application that helps you to import your translated words to Lingualeo service. To better experience please add this app to Today Notification center.", characterDelay: 3.0)
        test
            //.bind(to: self.loginInfoStack.rx.isHidden)
            .skip(1)
            .subscribe(onNext: { [unowned self] bool in
                print(bool)
                if bool == false {
                    NSAnimationContext.runAnimationGroup({ _ in
                        NSAnimationContext.current.duration = 5.0
                        self.loginInfoStack.animator().alphaValue = 1.0
                        
                    }, completionHandler: {
                        
                        print("animation completed")
                    })
                    
                }
            })
            .disposed(by: bag)
    }

    func bindUI() {
        
        let viewModel = LoginViewModel.init(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver())
 
        viewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.loginButton.isEnabled = valid
               
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
            .withLatestFrom(viewModel.credentialsValid)
            .filter { $0 }
            .debug()
            .flatMapLatest { [unowned self] valid in
                
                
                viewModel.login(email: self.emailTextField.stringValue, password: self.passwordTextField.stringValue)
                .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] authStatus in
                
                
                switch authStatus {
                case .unavailable:
                    break
                case .success(_):
                    self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "segue"), sender: nil)
                }
                LeoAPI.shared.state.accept(.unavailable)
            })
            .disposed(by: bag)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.view.window?.close()
    }
    
    
//    override func performSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) {
//        //self.view.window?.close()
//    }

//    override func perform() {
//        let animator = MyCustomSwiftAnimator()
//        let sourceVC  = self.sourceController as! NSViewController
//        let destVC = self.destinationController as! NSViewController
//        sourceVC.presentViewController(destVC, animator: animator)
//    }
    
}

