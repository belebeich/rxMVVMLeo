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
    @IBOutlet weak var emailTextField: CustomNSTextField!
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
    
    override func viewWillLayout() {
        
        let gradientLayer = CAGradientLayer()
        
        //        gradientLayer.colors = [NSColor.init(calibratedRed: 0.64, green: 0.4, blue: 0.49, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 0.168, green: 0.11, blue: 0.2, alpha: 1.0).cgColor]
        gradientLayer.colors = [NSColor.init(calibratedRed: 202/255, green: 196/255, blue: 187/255, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor]
        gradientLayer.frame = self.view.frame
        view.layer?.insertSublayer(gradientLayer, at: 0)
        
        
        
        self.emailTextField.customizeCaretColor()
        self.emailTextField.setNeedsDisplay()
    
    }
    
   

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setUI() {
        loginInfoStack.animator().alphaValue = 0.0
        
        // made it more neon
        let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
        
        // made resizeble NSTextField
        self.emailTextField.backgroundColor = NSColor.clear
        self.emailTextField.textColor = NSColor.white
        
        
        self.passwordTextField.backgroundColor = NSColor.clear
        self.passwordTextField.textColor = NSColor.white
        
        let placeholderColor = NSColor.white
        let placeholderParagraphStyle = NSMutableParagraphStyle()
        placeholderParagraphStyle.alignment = .right
        let placeholderFont = NSFont.init(name: "PFDinMono-Light", size: 13)
        let placeholderAttributes : [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.foregroundColor: placeholderColor, NSAttributedStringKey.font: placeholderFont!, NSAttributedStringKey.paragraphStyle: placeholderParagraphStyle]
        
        let emailPlaceholderString = NSAttributedString.init(string: "email", attributes: placeholderAttributes)
        let passwordPlaceholderString = NSAttributedString.init(string: "password", attributes: placeholderAttributes)
        self.emailTextField.placeholderAttributedString = emailPlaceholderString
        self.passwordTextField.placeholderAttributedString = passwordPlaceholderString
        
        
        
        //rgb(225, 216, 202) - ksg beige
        ///rgb(119, 110, 94) - brown/beige/gray - made it more beigy
        
        ///#E1D8CA
        
        
        
        
        
        
        
        let test = self.tesy.setTextWithTypeAnimation(typedText: "It's a demo MacOS Application that helps you to import your translated words to Lingualeo service. To better experience please add this app to Today Notification center.", characterDelay: 3.0)
        
        self.tesy.textColor = neonyellowColor
        self.tesy.font = NSFont(name: "PFDinMono-Regular", size: 13)
        self.tesy.sizeToFit()
        
        test
            .skip(1)
            .subscribe(onNext: { [unowned self] bool in
               
                if bool == false {
                    NSAnimationContext.runAnimationGroup({ _ in
                        NSAnimationContext.current.duration = 2.0
                        self.loginInfoStack.animator().alphaValue = 1.0
                        
                    }, completionHandler: {
                       self.emailTextField.selectText(self)
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
        
        emailTextField.rx.controlEvent
            .subscribe(onNext: {
                self.emailTextField.currentEditor()?.moveToBeginningOfDocument(self)
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

