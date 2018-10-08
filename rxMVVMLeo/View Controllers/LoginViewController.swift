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
    
    @IBOutlet var thirdMessage: NSTextView!
    @IBOutlet weak var okButton: NSButton!
    @IBOutlet weak var menuButtonView: NSImageView!
    @IBOutlet weak var tipView: NSView!
    @IBOutlet weak var menuBarImageView: NSImageView!
    @IBOutlet weak var notificationCenterImageView: NSImageView!
    @IBOutlet weak var loginInfoStack: NSStackView!
    @IBOutlet weak var firstMessage: NSTextView!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var emailTextField: CustomNSTextField!
    @IBOutlet weak var passwordTextField: CustomNSTextField!
    
    @IBOutlet var secondMessage: NSTextView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
        
    }
    
    private func disappearAnimation() {
        //self.tipView.animator().alphaValue = 1.0
        //self.tipView.layer?.anchorPoint = CGPoint.init(x: 0.0, y: -1.0)
        print("origin X: \(tipView.bounds.origin.x)")
        print("origin Y: \(tipView.bounds.origin.y)")
        print("max X: \(tipView.bounds.maxX)")
        print("max Y: \(tipView.bounds.maxY)")
        print("min X: \(tipView.bounds.minX)")
        print("min Y: \(tipView.bounds.minY)")
        
        let bounds = NSRect.init(x: self.tipView.bounds.origin.x, y: self.tipView.bounds.origin.y, width: self.tipView.bounds.width, height: self.tipView.bounds.height)
        let end = NSRect.init(x: self.tipView.bounds.origin.x, y: self.tipView.bounds.origin.y, width: self.tipView.bounds.width, height: 0)
        //let end = NSRect.init(x: self.tipView.bounds.midX, y: self.tipView.bounds.maxY, width: self.tipView.bounds.width, height: self.tipView.bounds.height)
        //self.tipView.wantsLayer = true
        let disappear = CABasicAnimation(keyPath: "bounds")
        disappear.fromValue = bounds
        disappear.toValue = end
        //disappear.
        disappear.duration = 1.0
        disappear.autoreverses = false
        disappear.fillMode = kCAFillModeBoth
        
        disappear.isRemovedOnCompletion = false

        tipView.layer?.add(disappear, forKey: "opacity")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
             //self.tipView.removeFromSuperview()

            self.tipView.isHidden = true
            self.okButton.isEnabled = false
        })
        
//        NSAnimationContext.runAnimationGroup({ _ in
//            NSAnimationContext.current.duration = 1.0
//            self.tipView.animator().alphaValue = 0.0
//        }, completionHandler: {
//            self.tipView.isHidden = true
//            self.okButton.isEnabled = false
//        })
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.okButton.isHidden = false
        })
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
        self.okButton.isHidden = true
        self.loginButton.isHidden = true
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
        let okButtonAttributedTitle = NSAttributedString.init(string: "Ok, got it!", attributes: buttonAttributes)
        
        self.loginButton.attributedTitle = buttonAttributedTitle
        self.okButton.attributedTitle = okButtonAttributedTitle
        
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
        
        
        
        self.firstMessage.textColor = neonyellowColor
        self.firstMessage.font = mainFont
        
        self.firstMessage.sizeToFit()
        
        
        self.secondMessage.textColor = neonyellowColor
        self.secondMessage.font = mainFont
        
        self.secondMessage.sizeToFit()
        
        
        self.thirdMessage.textColor = neonyellowColor
        self.thirdMessage.font = mainFont
        self.thirdMessage.sizeToFit()
        
        
    }

    func bindUI() {
        
        
        
        let viewModel = LoginViewModel.init(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver())
 
        viewModel.credentialsValid
            .drive(onNext: { [unowned self] valid in
                self.loginButton.isEnabled = valid
               
            })
            .disposed(by: bag)
        
        let firstMessage = self.firstMessage.setTextWithTypeAnimation(typedText: "It's a demo MacOS Application that helps you to import your translated words to LinguaLeo service. This app only works in Today Notification center. Please add it as shown below.", characterDelay: 3.0)
        
        firstMessage
            .skip(1)
            .subscribe(onNext: { [unowned self] bool in
                
                if bool == false {
                    
                    self.animation()
                    
                }
            })
            .disposed(by: bag)
        
        okButton.rx.tap
            .take(1)
            .flatMapFirst { [unowned self] _ -> Observable<Bool> in
                self.disappearAnimation()
                let secondMessage = self.secondMessage.setTextWithTypeAnimation(typedText: "You should be logged in to export words to LinguaLeo service. Now you can do it.", characterDelay: 3.0)

                return secondMessage

            }
            .subscribe(onNext: { [unowned self] bool in
                if bool == false {
                    //self.disappearAnimation()
                    
                    NSAnimationContext.runAnimationGroup({ _ in
                        NSAnimationContext.current.duration = 2.0
                        self.loginInfoStack.animator().alphaValue = 1.0
                    }, completionHandler: {
                       self.emailTextField.selectText(self)
                        self.loginButton.isHidden = false
                    })
                }
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
                    let thirdMessage = self.thirdMessage.setTextWithTypeAnimation(typedText: "Something went wrong, please try again!", characterDelay: 2.0)
                    thirdMessage
                        .subscribe(onNext: { _ in
                            
                        })
                        .disposed(by: self.bag)
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

extension LoginViewController {
    class FlippedView: NSView {
        override var isFlipped: Bool { return true }
    }
}
