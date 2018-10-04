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
    
    @IBOutlet weak var menuButtonView: NSImageView!
    @IBOutlet weak var tipView: NSView!
    @IBOutlet weak var menuBarImageView: NSImageView!
    @IBOutlet weak var notificationCenterImageView: NSImageView!
    @IBOutlet weak var loginInfoStack: NSStackView!
    @IBOutlet var firstMessage: NSTextView!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var emailTextField: CustomNSTextField!
    @IBOutlet weak var passwordTextField: CustomNSTextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
        
    }
    
    private func animation() {
        var animations = [CABasicAnimation]()
        
        menuBarImageView.isHidden = false
        let menuBarAnimation = CABasicAnimation(keyPath: "opacity")
        menuBarAnimation.fromValue = 0
        menuBarAnimation.toValue = 1
        menuBarAnimation.duration = 1.5
        menuBarImageView.layer?.add(menuBarAnimation, forKey: "opacity")
        
        menuButtonView.isHidden = false
        menuButtonView.layer?.masksToBounds = false
        menuButtonView.layer?.shadowColor = NSColor.white.cgColor
        menuButtonView.layer?.shadowRadius = 0
        menuButtonView.layer?.shadowOpacity = 1.0
        menuButtonView.layer?.shadowOffset = .zero
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = 1.5
        animations.append(opacityAnimation)
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 12
        glowAnimation.beginTime = 2.5
        glowAnimation.duration = CFTimeInterval(0.5)
        glowAnimation.fillMode = kCAFillModeRemoved
        glowAnimation.autoreverses = true
        glowAnimation.isRemovedOnCompletion = true
        animations.append(glowAnimation)
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 3
        menuButtonView.layer?.add(group, forKey: "group")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.notificationCenterImageView.isHidden = false
        })
        
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = CGPoint(x: tipView.bounds.width, y: notificationCenterImageView.frame.minY)
        position.toValue = CGPoint(x: notificationCenterImageView.frame.minX, y: notificationCenterImageView.frame.minY)
        position.duration = 1.5
        
        position.beginTime = CACurrentMediaTime() + 3
        position.autoreverses = false
        
        notificationCenterImageView.layer?.add(position, forKey: "group")
    }
    
    override func viewWillLayout() {
        
        let gradientLayer = CAGradientLayer()
        
        //        gradientLayer.colors = [NSColor.init(calibratedRed: 0.64, green: 0.4, blue: 0.49, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 0.168, green: 0.11, blue: 0.2, alpha: 1.0).cgColor]
        gradientLayer.colors = [NSColor.init(calibratedRed: 202/255, green: 196/255, blue: 187/255, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor]
        gradientLayer.frame = self.view.frame
        view.layer?.insertSublayer(gradientLayer, at: 0)
        
        let editor = self.emailTextField.window?.fieldEditor(true, for: self.emailTextField) as! NSTextView
        
        
        let rect = NSRect.init(x: 5.0, y: 10.0, width: 10.0, height: 2.0)
        
        editor.drawInsertionPoint(in: rect, color: NSColor.white, turnedOn: true)
         
        
        self.emailTextField.customizeCaretColor()
        self.passwordTextField.customizeCaretColor()
    }
    
    func setUI() {
        loginInfoStack.animator().alphaValue = 0.0
        self.menuButtonView.isHidden = true
        self.menuBarImageView.isHidden = true
        self.notificationCenterImageView.isHidden = true
        
        let mainFont = NSFont.init(name: "PFDinMono-Regular", size: 13)
        let placeholderFont = NSFont.init(name: "PFDinMono-Light", size: 13)
        
        // made it more neon
        let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
        let cgNeon = CGColor.init(red: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
        
        
        // made resizeble NSTextField
        self.emailTextField.backgroundColor = NSColor.clear
        self.emailTextField.textColor = NSColor.white
        
        let buttonParagraphStyle = NSMutableParagraphStyle()
        buttonParagraphStyle.alignment = .center
        
        let buttonAttributes : [NSAttributedStringKey:AnyObject] =
            [NSAttributedStringKey.foregroundColor: neonyellowColor,
             NSAttributedStringKey.font: mainFont!,
             NSAttributedStringKey.paragraphStyle: buttonParagraphStyle]
        
        let buttonAttributedTitle = NSAttributedString.init(string: "Login", attributes: buttonAttributes)
        
        self.loginButton.attributedTitle = buttonAttributedTitle
        //self.loginButton.layer?.backgroundColor = CGColor.clear
        self.loginButton.layer?.borderWidth = 1.0
        self.loginButton.layer?.borderColor = cgNeon
        self.loginButton.wantsLayer = true
        
        self.passwordTextField.backgroundColor = NSColor.clear
        self.passwordTextField.textColor = NSColor.white
        
        let placeholderColor = NSColor.white
        let placeholderParagraphStyle = NSMutableParagraphStyle()
        placeholderParagraphStyle.alignment = .right
        
        let placeholderAttributes : [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.foregroundColor: placeholderColor, NSAttributedStringKey.font: placeholderFont!, NSAttributedStringKey.paragraphStyle: placeholderParagraphStyle]
        
        let emailPlaceholderString = NSAttributedString.init(string: "email", attributes: placeholderAttributes)
        let passwordPlaceholderString = NSAttributedString.init(string: "password", attributes: placeholderAttributes)
        self.emailTextField.placeholderAttributedString = emailPlaceholderString
        self.passwordTextField.placeholderAttributedString = passwordPlaceholderString
        self.emailTextField.font = mainFont
        self.passwordTextField.font = mainFont
        
        //rgb(225, 216, 202) - ksg beige
        ///rgb(119, 110, 94) - brown/beige/gray - made it more beigy
        
        ///#E1D8CA
        
        let test = self.firstMessage.setTextWithTypeAnimation(typedText: "It's a demo MacOS Application that helps you to import your translated words to Lingualeo service. To better experience please add this app to Today Notification center.", characterDelay: 3.0)
        
        self.firstMessage.textColor = neonyellowColor
        self.firstMessage.font = mainFont
        
        self.firstMessage.sizeToFit()
        
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
        
        viewModel.requestWebPass()
        
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
    
    
    func animationOfTip() {
        
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

