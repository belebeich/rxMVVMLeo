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

final class MainViewController: NSViewController, BindableType {
  
  @IBOutlet weak private var sixthTextView: NSTextView!
  @IBOutlet weak private var writeToDeveloperButton: NSButton!
  @IBOutlet weak private var logoutButtons: NSStackView!
  @IBOutlet weak private var noButton: NSButton!
  @IBOutlet weak private var yesButton: NSButton!
  @IBOutlet weak private var logoutTextView: NSTextView!
  @IBOutlet weak private var userRefcodeTextView: NSTextView!
  @IBOutlet weak private var userAvailableTextView: NSTextView!
  @IBOutlet weak private var userKnownTextView: NSTextView!
  @IBOutlet weak private var userNativeTextView: NSTextView!
  @IBOutlet weak private var userNicknameTextView: NSTextView!
  @IBOutlet weak private var refcodeTextView: NSTextView!
  @IBOutlet weak private var availableTextView: NSTextView!
  @IBOutlet weak private var knownTextView: NSTextView!
  @IBOutlet weak private var nativeTextView: NSTextView!
  @IBOutlet weak private var nicknameTextView: NSTextView!
  @IBOutlet weak private var accountInfoTextView: NSTextView!
  @IBOutlet weak private var firstTextView: NSTextView!
  @IBOutlet weak private var secondTextView: NSTextView!
  @IBOutlet weak private var thirdTextView: NSTextView!
  @IBOutlet weak private var fourthTextView: NSTextView!
  @IBOutlet weak private var fifthTextView: NSTextView!
  @IBOutlet weak private var tipView: NSView!
  @IBOutlet weak private var menuButtonView: NSImageView!
  @IBOutlet weak private var notificationCenterImageView: NSImageView!
  @IBOutlet weak private var menuBarImageView: NSImageView!
  @IBOutlet weak private var introMessage: NSTextView!
  @IBOutlet weak private var tabView: NSTabView!
  @IBOutlet weak private var logoutButton: NSButton!
  @IBOutlet weak private var helpButton: NSButton!
  @IBOutlet weak private var accountButton: NSButton!
  
  private let disposeBag = DisposeBag()
  var viewModel: MainViewModel!
  
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
    view.window?.acceptsMouseMovedEvents = true
    buttonHover()
    shine()
  }
  
  func bindViewModel() {
    viewModel.user
      .bind { [weak self] info in
        guard let self = self, let user = info else { return }
        self.parsedInformation(of: user)
      }
      .disposed(by: disposeBag)
    
    accountButton.rx.tap
      .withLatestFrom(viewModel.user)
      .bind { [weak self] user in
        guard let self = self, let user = user else { return }
        self.tabView.selectTabViewItem(at: 0)
        self.updatedInformation(of: user)
      }
      .disposed(by: disposeBag)
    
    helpButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.tabView.selectTabViewItem(at: 1)
      }
      .disposed(by: disposeBag)
    
    helpButton.rx.tap
      .take(1)
      .flatMapLatest { [weak self] _ -> Observable<Bool> in
        guard let self = self else { return .just(true) }
        return self.introMessage.setTextWithTypeAnimation(typedText: StringKeys.MainScreen.introMessage, characterDelay: 3.0)
      }
      .filter { $0 == false }
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.notificationCenterAnimations()
      }
      .disposed(by: disposeBag)
    
    logoutButton.rx.tap
      .take(1)
      .flatMapLatest { [weak self] _ -> Observable<Bool> in
        guard let self = self else { return .just(true) }
        return self.logoutTextView.setTextWithTypeAnimation(typedText: StringKeys.MainScreen.logoutMessage, characterDelay: 3.0)
      }
      .filter { $0 == false }
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.logoutAnimation()
      }
      .disposed(by: disposeBag)
    
    logoutButton.rx.tap
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.tabView.selectTabViewItem(at: 2)
      }
      .disposed(by: disposeBag)
    
    noButton.rx.tap
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.tabView.selectTabViewItem(at: 0)
      }
      .disposed(by: disposeBag)
    
    yesButton.rx.tap
      .flatMapLatest { _ -> Observable<Bool> in
        return .just(true)
      }
      .bind(to: viewModel.loggedOut)
      .disposed(by: disposeBag)

    writeToDeveloperButton.rx.tap
      .flatMapLatest { _ -> Observable<Bool> in
        return .just(true)
      }
      .bind(to: viewModel.write)
      .disposed(by: disposeBag)
  }
}

private extension MainViewController {
  func setUI() {
    menuButtonView.isHidden = true
    menuBarImageView.isHidden = true
    notificationCenterImageView.isHidden = true
    logoutButtons.isHidden = true
    
    [firstTextView, secondTextView, thirdTextView, fourthTextView, fifthTextView]
      .forEach {
        $0?.textColor = NSColor.white
        $0?.font = Font.tips
        $0?.sizeToFit()
      }
    
    [introMessage, sixthTextView, logoutTextView]
      .forEach {
        $0?.textColor = Color.neonYellow
        $0?.font = Font.main
        $0?.sizeToFit()
      }
    
    [accountInfoTextView, nicknameTextView, nativeTextView, knownTextView, userKnownTextView, availableTextView, refcodeTextView, userNicknameTextView, userNativeTextView, userAvailableTextView, userRefcodeTextView, refcodeTextView]
      .forEach {
        $0?.textColor = NSColor.white
        $0?.font = Font.main
    }
  }
}

// MARK: - Animations
extension MainViewController {
  
  override func mouseEntered(with event: NSEvent) {
    writeToDeveloperButton.font = Font.developerLarge
    glowOn()
  }
  
  override func mouseExited(with event: NSEvent) {
    writeToDeveloperButton.font = Font.developerRegular
    glowOff()
  }
  
  typealias CompletionHandler = (_ success:Bool) -> Void
  
  private func drawingAnimations(textView: NSTextView, text: String, x: Double, y: Double, lenght: Double, completionHandler: @escaping CompletionHandler) {
    
    textView.setTextWithTypeAnimation(typedText: text, characterDelay: 5.0)
      .filter { $0 == false }
      .bind { [weak self] _ in
        guard let self = self else { return }
        let line = CAShapeLayer()
        line.lineWidth = 2.0
        line.shadowColor = CGColor.white
        line.shadowOffset = CGSize.zero
        line.shadowOpacity = 1.0
        line.lineCap = kCALineCapRound
        line.strokeEnd = 0.0
        line.strokeColor = CGColor.white
        line.shadowRadius = 5.0
        line.fillColor = CGColor.clear
        line.fillMode = kCAFillModeForwards
        let pt = NSBezierPath()
        pt.move(to: CGPoint(x: x, y: y))
        pt.line(to: CGPoint(x: x + lenght, y: y))
        line.path = pt.cgPath
        CATransaction.begin()
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.autoreverses = false
        line.strokeEnd = 1.0
        CATransaction.setCompletionBlock {
          completionHandler(true)
        }
        line.add(pathAnimation, forKey: nil)
        self.tabView.tabViewItem(at: 1).view?.layer?.addSublayer(line)
        CATransaction.commit()
      }
      .disposed(by: disposeBag)
  }
  
  private func logoutAnimation() {
    logoutButtons.isHidden = false
    let logout = CABasicAnimation(keyPath: "opacity")
    logout.fromValue = 0.0
    logout.toValue = 1.0
    logout.duration = 1.0
    logoutButtons.layer?.add(logout, forKey: nil)
  }
  
  private func buttonHover() {
    let area = NSTrackingArea(rect: writeToDeveloperButton.bounds,
                                   options: [.mouseEnteredAndExited, .activeAlways],
                                   owner: self,
                                   userInfo: nil)
    writeToDeveloperButton.addTrackingArea(area)
  }
  
  private func glowOn() {
    writeToDeveloperButton.layer?.masksToBounds = false
    writeToDeveloperButton.layer?.shadowColor = NSColor.white.cgColor
    writeToDeveloperButton.layer?.shadowRadius = 0.0
    writeToDeveloperButton.layer?.shadowOpacity = 1.0
    writeToDeveloperButton.layer?.shadowOffset = .zero
    
    let glow = CABasicAnimation(keyPath: "shadowRadius")
    glow.fromValue = 0.0
    glow.toValue = 5.0
    glow.duration = CFTimeInterval(0.5)
    glow.fillMode = kCAFillModeForwards
    glow.autoreverses = false
    glow.isRemovedOnCompletion = false
    
    writeToDeveloperButton.layer?.shadowRadius = 5.0
    writeToDeveloperButton.layer?.add(glow, forKey: nil)
  }
  
  private func glowOff() {
    let glow = CABasicAnimation(keyPath: "shadowRadius")
    glow.fromValue = 5.0
    glow.toValue = 0.0
    glow.duration = CFTimeInterval(0.5)
    glow.fillMode = kCAFillModeRemoved
    glow.autoreverses = false
    glow.isRemovedOnCompletion = false
    
    writeToDeveloperButton.layer?.shadowRadius = 0.0
    writeToDeveloperButton.layer?.shadowOpacity = 0.0
    writeToDeveloperButton.layer?.add(glow, forKey: nil)
  }
  
  private func shine() {
    writeToDeveloperButton.wantsLayer = true
    guard let view = writeToDeveloperButton else { return }
    
    let gradient = CAGradientLayer()
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: -0.02)
    gradient.frame = CGRect(x: 0, y: 0, width: (view.bounds.size.width)*3, height: (view.bounds.size.height))
    
    let lowerAlpha: CGFloat = 0.5
    let solid = NSColor(white: 1, alpha: 1).cgColor
    let clear = NSColor(white: 1, alpha: lowerAlpha).cgColor
    
    gradient.colors = [ solid, solid, clear, clear, solid, solid ]
    gradient.locations = [ 0, 0.3, 0.45, 0.55, 0.7, 1]
    
    let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
    theAnimation.duration = 2
    theAnimation.repeatCount = Float.infinity
    theAnimation.autoreverses = false
    theAnimation.isRemovedOnCompletion = false
    theAnimation.fillMode = kCAFillModeForwards
    theAnimation.fromValue = -((view.frame.size.width) * 2)
    theAnimation.toValue =  0
    
    gradient.add(theAnimation, forKey: nil)
    view.layer?.mask = gradient
  }
  
  private func updatedInformation(of user: User) {
    userNicknameTextView.string = user.nickname
    userNativeTextView.string = user.native
    userKnownTextView.string = "\(user.known)"
    userAvailableTextView.string = "\(user.available)"
    userRefcodeTextView.string = user.refcode
  }
  
  private func parsedInformation(of user: User) {
    accountInfoTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.accountInfo) { [weak self] in
      guard let self = self else { return }
      self.nicknameTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.nickname) {
        self.userNicknameTextView.setTextWithTypeAnimationSimple(typedText: user.nickname) {
          self.nativeTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.nativeLanguage) {
            self.userNativeTextView.setTextWithTypeAnimationSimple(typedText: user.native) {
              self.knownTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.knownWords) {
                self.userKnownTextView.setTextWithTypeAnimationSimple(typedText: "\(user.known)") {
                  self.availableTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.availableWords) {
                  self.userAvailableTextView.setTextWithTypeAnimationSimple(typedText: "\(user.available)") {
                      self.refcodeTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.refCode) {
                        self.userRefcodeTextView.setTextWithTypeAnimationSimple(typedText: user.refcode) { }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  private func notificationCenterAnimations() {
    var animations = [CABasicAnimation]()
    
    menuBarImageView.isHidden = false
    let menuBarAnimation = CABasicAnimation(keyPath: "opacity")
    menuBarAnimation.fromValue = 0
    menuBarAnimation.toValue = 1
    menuBarAnimation.duration = 1.5
    menuBarImageView.layer?.add(menuBarAnimation, forKey: nil)
    
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
    menuButtonView.layer?.add(group, forKey: nil)
    
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
    
    notificationCenterImageView.layer?.add(position, forKey: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
      guard let self = self else { return }
      self.drawingAnimations(textView: self.firstTextView, text: StringKeys.MainScreen.translateOptions, x: 167.0, y: 196.0, lenght: 48.0) { _ in
        self.drawingAnimations(textView: self.secondTextView, text: StringKeys.MainScreen.wordsInput, x: 167.0, y: 169.0, lenght:  48.0) { _ in
          self.drawingAnimations(textView: self.thirdTextView, text: StringKeys.MainScreen.translateTable, x: 167.0, y: 130, lenght: 48.0) { _ in
            self.drawingAnimations(textView: self.fourthTextView, text: StringKeys.MainScreen.selectedRow, x: 167.0, y: 107.0, lenght:  48.0) { _ in
              self.drawingAnimations(textView: self.fifthTextView, text: StringKeys.MainScreen.availableWordsToAdd, x: 167.0, y: 67.0, lenght: 158.0, completionHandler: { _ in self.sixthTextView.setTextWithTypeAnimationSimple(typedText: StringKeys.MainScreen.apiMessage) {  } })
            }
          }
        }
      }
    }
  }
}
