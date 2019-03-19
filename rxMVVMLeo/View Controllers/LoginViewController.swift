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

final class LoginViewController: NSViewController, BindableType {
  
  private let bag = DisposeBag()
  var viewModel: LoginViewModel!
  
  @IBOutlet weak private var tipViewConstraint: NSLayoutConstraint!
  @IBOutlet weak private var tipStackView: NSStackView!
  @IBOutlet weak private var thirdMessage: NSTextView!
  @IBOutlet weak private var okButton: NSButton!
  @IBOutlet weak private var menuButtonView: NSImageView!
  @IBOutlet weak private var tipView: NSView!
  @IBOutlet weak private var menuBarImageView: NSImageView!
  @IBOutlet weak private var notificationCenterImageView: NSImageView!
  @IBOutlet weak private var loginInfoStack: NSStackView!
  @IBOutlet weak private var firstMessage: NSTextView!
  @IBOutlet weak private var loginButton: NSButton!
  @IBOutlet weak private var emailTextField: CustomNSTextField!
  @IBOutlet weak private var passwordTextField: CustomNSTextField!
  @IBOutlet weak private var secondMessage: NSTextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }
  
  override func viewWillAppear() {
    view.window?.titlebarAppearsTransparent = true
    view.window?.titleVisibility = .hidden
    view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
  }
  
  override func viewWillLayout() {
    view.layer?.backgroundColor = NSColor.init(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor
    emailTextField.customizeCaretColor()
    passwordTextField.customizeCaretColor()
  }
  
  func bindViewModel() {
    viewModel.credentialsValidation(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver())
      .drive(onNext: { [unowned self] valid in
        self.loginButton.isEnabled = valid
      })
      .disposed(by: bag)
    
    let login = Observable.of(passwordTextField.rx.controlEvent, loginButton.rx.tap)
    
    login
      .merge()
      .withLatestFrom(viewModel.credentialsValid)
      .filter { $0 }
      .flatMapLatest { [unowned self] valid in
        self.viewModel.login(email: self.emailTextField.rx.text.orEmpty.asDriver(), password: self.passwordTextField.rx.text.orEmpty.asDriver())
          .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
      }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] status in
        if status == false {
          self.thirdMessage.setTextWithTypeAnimationSimple(typedText: "Something went wrong, please try again!") {  }
        }
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
        self.tipStackViewAnimation()
        let secondMessage = self.secondMessage.setTextWithTypeAnimation(typedText: "You should be logged in to export words to LinguaLeo service. Now you can do it.", characterDelay: 3.5)
        return secondMessage
      }
      .subscribe(onNext: { [unowned self] bool in
        self.okButton.isEnabled = false
        if bool == false {
          self.loginStackViewAnimation()
        }
      })
      .disposed(by: bag)
    
    emailTextField.rx.controlEvent
      .subscribe(onNext: {
        self.passwordTextField.selectText(self)
      })
      .disposed(by: bag)
  }
}

// MARK: - Set UI
private extension LoginViewController {
  func setUI() {
    loginInfoStack.isHidden = true
    loginInfoStack.animator().alphaValue = 0.0
    menuButtonView.isHidden = true
    menuBarImageView.isHidden = true
    okButton.isHidden = true
    loginButton.isHidden = true
    notificationCenterImageView.isHidden = true
    
    let mainFont = NSFont.init(name: "PFDinMono-Regular", size: 13)
    
    let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
    
    emailTextField.backgroundColor = NSColor.clear
    emailTextField.textColor = NSColor.white
    
    let buttonParagraphStyle = NSMutableParagraphStyle()
    buttonParagraphStyle.alignment = .center
    
    if let buttonFont = NSFont.init(name: "PFDinMono-Regular", size: 13) {
      let buttonAttributes : [NSAttributedStringKey:AnyObject] =
        [NSAttributedStringKey.foregroundColor: neonyellowColor,
         NSAttributedStringKey.font: buttonFont,
         NSAttributedStringKey.paragraphStyle: buttonParagraphStyle]
      
      let buttonAttributedTitle = NSAttributedString.init(string: "Login", attributes: buttonAttributes)
      let okButtonAttributedTitle = NSAttributedString.init(string: "Ok, got it!", attributes: buttonAttributes)
      
      loginButton.attributedTitle = buttonAttributedTitle
      okButton.attributedTitle = okButtonAttributedTitle
    }
    
    passwordTextField.backgroundColor = NSColor.clear
    passwordTextField.textColor = NSColor.white
    
    let placeholderColor = NSColor.white
    let placeholderParagraphStyle = NSMutableParagraphStyle()
    placeholderParagraphStyle.alignment = .right
    
    if let placeholderFont = NSFont.init(name: "PFDinMono-Light", size: 13) {
      let placeholderAttributes : [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.foregroundColor: placeholderColor, NSAttributedStringKey.font: placeholderFont, NSAttributedStringKey.paragraphStyle: placeholderParagraphStyle]
      
      let emailPlaceholderString = NSAttributedString.init(string: "email", attributes: placeholderAttributes)
      let passwordPlaceholderString = NSAttributedString.init(string: "password", attributes: placeholderAttributes)
      emailTextField.placeholderAttributedString = emailPlaceholderString
      passwordTextField.placeholderAttributedString = passwordPlaceholderString
    }
    
    emailTextField.font = mainFont
    passwordTextField.font = mainFont
    
    firstMessage.textColor = neonyellowColor
    firstMessage.font = mainFont
    firstMessage.sizeToFit()
    
    secondMessage.textColor = neonyellowColor
    secondMessage.font = mainFont
    secondMessage.sizeToFit()
    
    thirdMessage.textColor = neonyellowColor
    thirdMessage.font = mainFont
    thirdMessage.sizeToFit()
  }
}

// MARK: - Animations
private extension LoginViewController {
  func loginStackViewAnimation() {
    loginInfoStack.isHidden = false
    NSAnimationContext.runAnimationGroup({ [weak self] context in
      context.duration = 1.5
      self?.loginInfoStack.animator().alphaValue = 1.0
      }) { [weak self] in
        self?.emailTextField.selectText(self)
        self?.loginButton.isHidden = false
    }
  }
  
  func tipStackViewAnimation() {
    NSAnimationContext.runAnimationGroup({ [weak self] context in
      context.duration = 1.5
      context.allowsImplicitAnimation = true
      self?.tipViewConstraint.constant = 0.0
      self?.view.layoutSubtreeIfNeeded()
    })
  }
  
  func animation() {
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
    glowAnimation.toValue = 14
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
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
      self?.notificationCenterImageView.isHidden = false
    }
    
    let position = CABasicAnimation(keyPath: "position")
    position.fromValue = CGPoint(x: tipView.bounds.width, y: notificationCenterImageView.frame.minY)
    position.toValue = CGPoint(x: notificationCenterImageView.frame.minX, y: notificationCenterImageView.frame.minY)
    position.duration = 1.5
    
    position.beginTime = CACurrentMediaTime() + 3
    position.autoreverses = false
    
    notificationCenterImageView.layer?.add(position, forKey: "group")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
      self?.okButton.isHidden = false
    }
  }
}
