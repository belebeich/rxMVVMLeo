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
import RxGesture

class LoginViewController: NSViewController {
    
    
    let bag = DisposeBag()
    
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var tokenLabel: NSTextField!
    
    @IBOutlet weak var logoutButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        bindUI()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func bindUI() {
        
        let viewModel = LoginViewModel.init(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver())
        emailTextField.stringValue = "appleseedjohnbon@yandex.ru"
        //passwordTextField.stringValue = "sbnCV8bmzTb0"
        
        
        
        viewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.loginButton.isEnabled = valid
                print(valid)
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
            .withLatestFrom(viewModel.credentialsValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid in
                
                
                viewModel.login(email: self.emailTextField.stringValue, password: self.passwordTextField.stringValue)
                .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] authStatus in
                    self.tokenLabel.stringValue = authStatus
                
                
                if authStatus != "" {
                    self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "segue"), sender: self)
                }
                
                
            })
            .disposed(by: bag)
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                viewModel.logout()
            })
            .disposed(by: bag)
            
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.view.window?.close()
//        let VC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "TranslateViewController"))
//        self.presentViewControllerAsModalWindow(VC as! NSViewController)
        //self.presenting(VC, animated: false, completion: nil)
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

