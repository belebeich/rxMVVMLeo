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
  
  private let disposeBag = DisposeBag()
  var viewModel: LoginViewModel!
  
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
    view.layer?.backgroundColor = Color.beige
    emailTextField.customizeCaretColor()
    passwordTextField.customizeCaretColor()
  }
  
  func bindViewModel() {

    emailTextField.rx.text.orEmpty
        .bind(to: viewModel.email)
        .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
        .bind(to: viewModel.password)
        .disposed(by: disposeBag)
    
    viewModel.credentialsValid
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
    
    Observable.of(passwordTextField.rx.controlEvent, loginButton.rx.tap)
        .merge()
        .withLatestFrom(viewModel.credentialsValid)
        .distinctUntilChanged()
        .bind(to: viewModel.loginInitiated)
        .disposed(by: disposeBag)
    
    viewModel.loginInitiated
        .withLatestFrom(viewModel.signedIn.skip(1))
        .filter { $0 == false }
        .bind { [weak self] _ in
            guard let self = self else { return }
            self.thirdMessage.setTextWithTypeAnimationSimple(typedText: StringKeys.LoginScreen.wrongMessage) {  }
        }
        .disposed(by: disposeBag)
    
    firstMessage.setTextWithTypeAnimation(typedText: StringKeys.LoginScreen.firstMessage, characterDelay: 3.0)
      .skip(1)
      .filter { $0 == false }
      .bind{ [weak self] bool in
        guard let self = self else { return }
        self.notificationCenterAnimation()
      }
      .disposed(by: disposeBag)
    
    okButton.rx.tap
      .take(1)
      .flatMapFirst { [weak self] _ -> Observable<Bool> in
        guard let self = self else { return .just(true) }
        self.tipStackViewAnimation()
        self.okButton.isEnabled = false
        return self.secondMessage.setTextWithTypeAnimation(typedText: StringKeys.LoginScreen.secondMessage, characterDelay: 3.5)
      }
      .filter { $0 == false }
      .bind { [weak self] bool in
        guard let self = self else { return }
        self.loginStackViewAnimation()
      }
      .disposed(by: disposeBag)
    
    emailTextField.rx.controlEvent
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.passwordTextField.selectText(self)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Set UI
private extension LoginViewController {
  func setUI() {
   
    [loginInfoStack, menuButtonView, menuBarImageView, loginButton, okButton, notificationCenterImageView]
      .forEach {
        $0?.isHidden = true
      }
    loginInfoStack.animator().alphaValue = 0.0
    
    [emailTextField, passwordTextField]
      .forEach {
        $0?.backgroundColor = NSColor.clear
        $0?.textColor = NSColor.white
      }
    
    let buttonParagraphStyle = NSMutableParagraphStyle()
    buttonParagraphStyle.alignment = .center
    
    if let buttonFont = Font.main {
      let buttonAttributes : [NSAttributedStringKey:AnyObject] =
        [NSAttributedStringKey.foregroundColor: Color.neonYellow,
         NSAttributedStringKey.font: buttonFont,
         NSAttributedStringKey.paragraphStyle: buttonParagraphStyle]
      
      let buttonAttributedTitle = NSAttributedString(string: StringKeys.LoginScreen.login, attributes: buttonAttributes)
      let okButtonAttributedTitle = NSAttributedString(string: StringKeys.LoginScreen.gotcha, attributes: buttonAttributes)
      
      loginButton.attributedTitle = buttonAttributedTitle
      okButton.attributedTitle = okButtonAttributedTitle
    }
    
    let placeholderColor = NSColor.white
    let placeholderParagraphStyle = NSMutableParagraphStyle()
    placeholderParagraphStyle.alignment = .right
    
    if let placeholderFont = Font.main {
      let placeholderAttributes : [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.foregroundColor: placeholderColor, NSAttributedStringKey.font: placeholderFont, NSAttributedStringKey.paragraphStyle: placeholderParagraphStyle]
      
      let emailPlaceholderString = NSAttributedString(string: StringKeys.LoginScreen.email, attributes: placeholderAttributes)
      let passwordPlaceholderString = NSAttributedString(string: StringKeys.LoginScreen.password, attributes: placeholderAttributes)
      emailTextField.placeholderAttributedString = emailPlaceholderString
      passwordTextField.placeholderAttributedString = passwordPlaceholderString
    }
    
    [emailTextField, passwordTextField]
      .forEach {
        $0?.font = Font.main
      }
    
    [firstMessage, secondMessage, thirdMessage]
      .forEach {
        $0?.textColor = Color.neonYellow
        $0?.font = Font.main
        $0?.sizeToFit()
      }
  }
}

// MARK: - Animations
private extension LoginViewController {
  func loginStackViewAnimation() {
    loginInfoStack.isHidden = false
    NSAnimationContext.runAnimationGroup({ [weak self] context in
      guard let self = self else { return }
      context.duration = 1.5
      self.loginInfoStack.animator().alphaValue = 1.0
      }) { [weak self] in
        guard let self = self else { return }
        self.emailTextField.selectText(self)
        self.loginButton.isHidden = false
    }
  }
  
  func tipStackViewAnimation() {
    NSAnimationContext.runAnimationGroup({ [weak self] context in
      guard let self = self else { return }
      context.duration = 1.5
      context.allowsImplicitAnimation = true
      self.tipViewConstraint.constant = 0.0
      self.view.layoutSubtreeIfNeeded()
    })
  }
  
  func notificationCenterAnimation() {
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
      guard let self = self else { return }
      self.notificationCenterImageView.isHidden = false
    }
    
    let position = CABasicAnimation(keyPath: "position")
    position.fromValue = CGPoint(x: tipView.bounds.width, y: notificationCenterImageView.frame.minY)
    position.toValue = CGPoint(x: notificationCenterImageView.frame.minX, y: notificationCenterImageView.frame.minY)
    position.duration = 1.5
    
    position.beginTime = CACurrentMediaTime() + 3
    position.autoreverses = false
    
    notificationCenterImageView.layer?.add(position, forKey: "group")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
      guard let self = self else { return }
      self.okButton.isHidden = false
    }
  }
}
