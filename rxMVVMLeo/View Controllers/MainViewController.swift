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

class MainViewController: NSViewController, BindableType {
  
  private let bag = DisposeBag()
  var viewModel: MainViewModel!
  
  @IBOutlet weak var sixthTextView: NSTextView!
  @IBOutlet weak var writeToDeveloperButton: NSButton!
  @IBOutlet weak var logoutButtons: NSStackView!
  @IBOutlet weak var noButton: NSButton!
  @IBOutlet weak var yesButton: NSButton!
  @IBOutlet weak var logoutTextView: NSTextView!
  @IBOutlet weak var userRefcodeTextView: NSTextView!
  @IBOutlet weak var userAvailableTextView: NSTextView!
  @IBOutlet weak var userKnownTextView: NSTextView!
  @IBOutlet weak var userNativeTextView: NSTextView!
  @IBOutlet weak var userNicknameTextView: NSTextView!
  @IBOutlet weak var refcodeTextView: NSTextView!
  @IBOutlet weak var availableTextView: NSTextView!
  @IBOutlet weak var knownTextView: NSTextView!
  @IBOutlet weak var nativeTextView: NSTextView!
  @IBOutlet weak var nicknameTextView: NSTextView!
  @IBOutlet weak var accountInfoTextView: NSTextView!
  @IBOutlet weak var firstTextView: NSTextView!
  @IBOutlet weak var secondTextView: NSTextView!
  @IBOutlet weak var thirdTextView: NSTextView!
  @IBOutlet weak var fourthTextView: NSTextView!
  @IBOutlet weak var fifthTextView: NSTextView!
  @IBOutlet weak var tipView: NSView!
  @IBOutlet weak var menuButtonView: NSImageView!
  @IBOutlet weak var notificationCenterImageView: NSImageView!
  @IBOutlet weak var menuBarImageView: NSImageView!
  @IBOutlet weak var introMessage: NSTextView!
  @IBOutlet weak var tabView: NSTabView!
  @IBOutlet weak var logoutButton: NSButton!
  @IBOutlet weak var helpButton: NSButton!
  @IBOutlet weak var accountButton: NSButton!
  
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
    view.window?.acceptsMouseMovedEvents = true
    buttonHover()
    shine()
  }
  
  func bindViewModel() {
    viewModel.accountInfo()
      .subscribe(onNext: { [unowned self] info in
        guard let user = info else { return }
        self.parsedInformation(of: user)
      })
      .disposed(by: bag)
    
    accountButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.tabView.selectTabViewItem(at: 0)
        self.viewModel.accountInfo()
          .subscribe(onNext: { info in
            guard let user = info else { return }
            self.updatedInformation(of: user)
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
    
    helpButton.rx.tap
      .subscribe(onNext: { [unowned self] in
        self.tabView.selectTabViewItem(at: 1)
      })
      .disposed(by: bag)
    
    helpButton.rx.tap
      .take(1)
      .subscribe(onNext: { [unowned self] in
        self.helpTab()
      })
      .disposed(by: bag)
    
    logoutButton.rx.tap
      .take(1)
      .subscribe(onNext: { [unowned self] in
        self.logoutTab()
      })
      .disposed(by: bag)
    
    logoutButton.rx.tap
      .subscribe(onNext: {
        self.tabView.selectTabViewItem(at: 2)
      })
      .disposed(by: bag)
    
    noButton.rx.tap
      .subscribe(onNext: {
        self.tabView.selectTabViewItem(at: 0)
      })
      .disposed(by: bag)
    
    yesButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.logout()
      })
      .disposed(by: bag)
    
    writeToDeveloperButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.writeToDeveloper()
      })
      .disposed(by: bag)
  }
}

private extension MainViewController {
  func setUI() {
    let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
    let mainFont = NSFont.init(name: "PFDinMono-Regular", size: 13)
    let tipsFont = NSFont.init(name: "PFDinMono-Regular", size: 11)
    
    menuButtonView.isHidden = true
    menuBarImageView.isHidden = true
    notificationCenterImageView.isHidden = true
    logoutButtons.isHidden = true
    
    introMessage.textColor = neonyellowColor
    introMessage.font = mainFont
    introMessage.sizeToFit()
    
    firstTextView.textColor = NSColor.white
    firstTextView.font = tipsFont
    firstTextView.sizeToFit()
    
    secondTextView.textColor = NSColor.white
    secondTextView.font = tipsFont
    secondTextView.sizeToFit()
    
    thirdTextView.textColor = NSColor.white
    thirdTextView.font = tipsFont
    thirdTextView.sizeToFit()
    
    fourthTextView.textColor = NSColor.white
    fourthTextView.font = tipsFont
    fourthTextView.sizeToFit()
    
    fifthTextView.textColor = NSColor.white
    fifthTextView.font = tipsFont
    fifthTextView.sizeToFit()
    
    sixthTextView.textColor = neonyellowColor
    sixthTextView.font = mainFont
    sixthTextView.sizeToFit()
    
    accountInfoTextView.textColor = NSColor.white
    accountInfoTextView.font = mainFont
    
    nicknameTextView.textColor = NSColor.white
    nicknameTextView.font = mainFont
    nativeTextView.textColor = NSColor.white
    nativeTextView.font = mainFont
    knownTextView.textColor = NSColor.white
    knownTextView.font = mainFont
    availableTextView.textColor = NSColor.white
    availableTextView.font = mainFont
    refcodeTextView.textColor = NSColor.white
    refcodeTextView.font = mainFont
    userNicknameTextView.textColor = NSColor.white
    userNicknameTextView.font = mainFont
    userNativeTextView.textColor = NSColor.white
    userNativeTextView.font = mainFont
    userKnownTextView.textColor = NSColor.white
    userKnownTextView.font = mainFont
    userAvailableTextView.textColor = NSColor.white
    userAvailableTextView.font = mainFont
    userRefcodeTextView.textColor = NSColor.white
    userRefcodeTextView.font = mainFont
    refcodeTextView.textColor = NSColor.white
    refcodeTextView.font = mainFont
    
    logoutTextView.textColor = neonyellowColor
    logoutTextView.font = mainFont
  }
  
  func helpTab() {
    let introMessage = self.introMessage.setTextWithTypeAnimation(typedText: "This app is designed to work only in Notification Center. It helps you to quickly translate and add some words to your LinguaLeo account.", characterDelay: 3.0)
    
    introMessage
      .subscribe(onNext: { [unowned self] bool in
        if bool == false {
          self.animation()
        }
      })
      .disposed(by: bag)
  }
  
  func logoutTab() {
    let logoutMessage = self.logoutTextView.setTextWithTypeAnimation(typedText: "Do you really want to logout from LinguaLeo account and quit from the app?", characterDelay: 3.0)
    
    logoutMessage
      .subscribe(onNext: { [unowned self] bool in
        if bool == false {
          self.logoutAnimation()
        }
      })
      .disposed(by: bag)
  }
}

// MARK: - Animations
extension MainViewController {
  
  override func mouseEntered(with event: NSEvent) {
    writeToDeveloperButton.font = NSFont.init(name: "PFDinMono-Regular", size: 16)
    glowOn()
  }
  
  override func mouseExited(with event: NSEvent) {
    writeToDeveloperButton.font = NSFont.init(name: "PFDinMono-Regular", size: 15)
    glowOff()
  }
  
  typealias CompletionHandler = (_ success:Bool) -> Void
  
  private func drawingAnimations(textView: NSTextView, text: String, x: Double, y: Double, lenght: Double, completionHandler: @escaping CompletionHandler) {
    
    let text = textView.setTextWithTypeAnimation(typedText: text, characterDelay: 5.0)
    
    text
      .subscribe(onNext: { [unowned self] bool in
        if bool == false {
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
      })
      .disposed(by: bag)
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
    let area = NSTrackingArea.init(rect: writeToDeveloperButton.bounds,
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
    accountInfoTextView.setTextWithTypeAnimationSimple(typedText: "Account info:") { [weak self] in
      guard let `self` = self else {
        return
      }
      self.nicknameTextView.setTextWithTypeAnimationSimple(typedText: "Nickname:") {
        self.userNicknameTextView.setTextWithTypeAnimationSimple(typedText: user.nickname) {
          self.nativeTextView.setTextWithTypeAnimationSimple(typedText: "Native language:") {
            self.userNativeTextView.setTextWithTypeAnimationSimple(typedText: user.native) {
              self.knownTextView.setTextWithTypeAnimationSimple(typedText: "Known words:") {
                self.userKnownTextView.setTextWithTypeAnimationSimple(typedText: "\(user.known)") {
                  self.availableTextView.setTextWithTypeAnimationSimple(typedText: "Available words:") {
                  self.userAvailableTextView.setTextWithTypeAnimationSimple(typedText: "\(user.available)") {
                      self.refcodeTextView.setTextWithTypeAnimationSimple(typedText: "Reference code:") {
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
  
  private func animation() {
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
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
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
      guard let `self` = self else {
        return
      }
      self.drawingAnimations(textView: self.firstTextView, text: "translate options", x: 167.0, y: 196.0, lenght: 48.0) { _ in
        self.drawingAnimations(textView: self.secondTextView, text: "words input", x: 167.0, y: 169.0, lenght:  48.0) {_ in
          self.drawingAnimations(textView: self.thirdTextView, text: "translates table will appear here", x: 167.0, y: 130, lenght: 48.0) { _ in
            self.drawingAnimations(textView: self.fourthTextView, text: "enables with selected row", x: 167.0, y: 107.0, lenght:  48.0) { _ in
              self.drawingAnimations(textView: self.fifthTextView, text: "available words to add", x: 167.0, y: 67.0, lenght: 158.0, completionHandler: { _ in self.sixthTextView.setTextWithTypeAnimationSimple(typedText: "UrbanDictionary and LinguaLeo are used now as translate options.") {  } })
            }
          }
        }
      }
    }
  }
}
