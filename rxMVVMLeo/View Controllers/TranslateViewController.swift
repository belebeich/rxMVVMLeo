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

    @IBOutlet weak var writeToDeveloperButton: NSButton!
    @IBOutlet weak var logoutButtons: NSStackView!
    @IBOutlet weak var noButton: NSButton!
    @IBOutlet weak var yesButton: NSButton!
    @IBOutlet var logoutTextView: NSTextView!
    @IBOutlet var userRefcodeTextView: NSTextView!
    @IBOutlet var userAvailableTextView: NSTextView!
    @IBOutlet var userKnownTextView: NSTextView!
    @IBOutlet var userNativeTextView: NSTextView!
    @IBOutlet var userNicknameTextView: NSTextView!
    @IBOutlet var refcodeTextView: NSTextView!
    @IBOutlet var availableTextView: NSTextView!
    @IBOutlet var knownTextView: NSTextView!
    @IBOutlet var nativeTextView: NSTextView!
    @IBOutlet var nicknameTextView: NSTextView!
    @IBOutlet var accountInfoTextView: NSTextView!
    
    @IBOutlet var firstTextView: NSTextView!
    @IBOutlet var secondTextView: NSTextView!
    @IBOutlet var thirdTextView: NSTextView!
    @IBOutlet var fourthTextView: NSTextView!
    @IBOutlet var fifthTextView: NSTextView!
    @IBOutlet weak var tipView: NSView!
    @IBOutlet weak var menuButtonView: NSImageView!
    @IBOutlet weak var notificationCenterImageView: NSImageView!
    @IBOutlet weak var menuBarImageView: NSImageView!
    @IBOutlet var introMessage: NSTextView!
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var logoutButton: NSButton!
    @IBOutlet weak var helpButton: NSButton!
    @IBOutlet weak var accountButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
        
    }
    
    
    
    override func viewWillLayout() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [NSColor.init(calibratedRed: 202/255, green: 196/255, blue: 187/255, alpha: 1.0).cgColor, NSColor.init(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor]
        gradientLayer.frame = self.view.bounds
        self.view.layer?.insertSublayer(gradientLayer, at: 0)
        
        self.view.wantsLayer = true
        
        self.shine()
        self.view.window?.acceptsMouseMovedEvents = true
        self.buttonHover()
    }
    

    func setUI() {
        let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
        let mainFont = NSFont.init(name: "PFDinMono-Regular", size: 13)
        let tipsFont = NSFont.init(name: "PFDinMono-Regular", size: 11)
        
        self.menuButtonView.isHidden = true
        self.menuBarImageView.isHidden = true
        self.notificationCenterImageView.isHidden = true
        self.logoutButtons.isHidden = true
        
        
        
        self.introMessage.textColor = neonyellowColor
        self.introMessage.font = mainFont
        self.introMessage.sizeToFit()
        
        self.firstTextView.textColor = NSColor.white
        self.firstTextView.font = tipsFont
        self.firstTextView.sizeToFit()
        
        self.secondTextView.textColor = NSColor.white
        self.secondTextView.font = tipsFont
        self.secondTextView.sizeToFit()
        
        self.thirdTextView.textColor = NSColor.white
        self.thirdTextView.font = tipsFont
        self.thirdTextView.sizeToFit()
        
        self.fourthTextView.textColor = NSColor.white
        self.fourthTextView.font = tipsFont
        self.fourthTextView.sizeToFit()
        
        self.fifthTextView.textColor = NSColor.white
        self.fifthTextView.font = tipsFont
        self.fifthTextView.sizeToFit()
        
        self.accountInfoTextView.textColor = NSColor.white
        self.accountInfoTextView.font = mainFont
        
        self.nicknameTextView.textColor = NSColor.white
        self.nicknameTextView.font = mainFont
        self.nativeTextView.textColor = NSColor.white
        self.nativeTextView.font = mainFont
        self.knownTextView.textColor = NSColor.white
        self.knownTextView.font = mainFont
        self.availableTextView.textColor = NSColor.white
        self.availableTextView.font = mainFont
        self.refcodeTextView.textColor = NSColor.white
        self.refcodeTextView.font = mainFont
        self.userNicknameTextView.textColor = NSColor.white
        self.userNicknameTextView.font = mainFont
        self.userNativeTextView.textColor = NSColor.white
        self.userNativeTextView.font = mainFont
        self.userKnownTextView.textColor = NSColor.white
        self.userKnownTextView.font = mainFont
        self.userAvailableTextView.textColor = NSColor.white
        self.userAvailableTextView.font = mainFont
        self.userRefcodeTextView.textColor = NSColor.white
        self.refcodeTextView.font = mainFont
        
        self.logoutTextView.textColor = neonyellowColor
        self.logoutTextView.font = mainFont
        
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
    
    
    func bindUI() {
        
        let viewModel = MainViewModel()
        
        viewModel.accountInfo()
            .subscribe(onNext: { [unowned self] info in
                guard let user = info else { return }
                    
                self.parsedInformation(of: user)
                
            })
            .disposed(by: bag)
        
        accountButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tabView.selectTabViewItem(at: 0)
                viewModel.accountInfo()
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
                viewModel.logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { 
                    NSApp.terminate(self)
                })
            })
            
            .disposed(by: bag)
        
        writeToDeveloperButton.rx.tap
            .subscribe(onNext: {
                viewModel.writeToDeveloper()
            })
            .disposed(by: bag)
    }
}


extension MainViewController {
    
    // MARK: - Animations & UI
    
    override func mouseEntered(with event: NSEvent) {
        writeToDeveloperButton.font = NSFont.init(name: "PFDinMono-Regular", size: 16)
    }
    
    override func mouseExited(with event: NSEvent) {
        writeToDeveloperButton.font = NSFont.init(name: "PFDinMono-Regular", size: 15)
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
        self.logoutButtons.isHidden = false
        let logout = CABasicAnimation(keyPath: "opacity")
        logout.fromValue = 0.0
        logout.toValue = 1.0
        logout.duration = 1.0
        self.logoutButtons.layer?.add(logout, forKey: nil)
        
    }
    
    private func buttonHover() {
        let area = NSTrackingArea.init(rect: writeToDeveloperButton.bounds,
                                       options: [.mouseEnteredAndExited, .activeAlways],
                                       owner: self,
                                       userInfo: nil)
        writeToDeveloperButton.addTrackingArea(area)
        
        
    }
    
    
    
    private func shine() {
        
        self.writeToDeveloperButton.wantsLayer = true
        guard let view = self.writeToDeveloperButton else { return }
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: -0.02)
        gradient.frame = CGRect(x: 0, y: 0, width: (view.bounds.size.width)*3, height: (view.bounds.size.height))
        
        let lowerAlpha: CGFloat = 0.5
        let solid = NSColor(white: 1, alpha: 1).cgColor
        let clear = NSColor(white: 1, alpha: lowerAlpha).cgColor
        
        gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
        gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]
        
        let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        theAnimation.duration = 2
        theAnimation.repeatCount = Float.infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = false
        theAnimation.fillMode = kCAFillModeForwards
        theAnimation.fromValue = -((view.frame.size.width) * 2)
        theAnimation.toValue =  0
        gradient.add(theAnimation, forKey: "animateLayer")
        
        view.layer?.mask = gradient
    }
    
    private func updatedInformation(of user: User) {
        self.userNicknameTextView.string = user.nickname
        self.userNativeTextView.string = user.native
        self.userKnownTextView.string = "\(user.known)"
        self.userAvailableTextView.string = "\(user.available)"
        self.userRefcodeTextView.string = user.refcode
    }
    
    private func parsedInformation(of user: User) {
        self.accountInfoTextView.setTextWithTypeAnimationSimple(typedText: "Account info:") {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.notificationCenterImageView.isHidden = false
        })
        
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = CGPoint(x: tipView.bounds.width, y: notificationCenterImageView.frame.minY)
        position.toValue = CGPoint(x: notificationCenterImageView.frame.minX, y: notificationCenterImageView.frame.minY)
        position.duration = 1.5
        
        position.beginTime = CACurrentMediaTime() + 3
        position.autoreverses = false
        
        notificationCenterImageView.layer?.add(position, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: { [unowned self] in
            self.drawingAnimations(textView: self.firstTextView, text: "translate options", x: 179.0, y: 196.0, lenght: 48.0) { _ in
                self.drawingAnimations(textView: self.secondTextView, text: "words input", x: 179.0, y: 169.0, lenght:  48.0) {_ in
                    self.drawingAnimations(textView: self.thirdTextView, text: "translates table will appear here", x: 179.0, y: 130, lenght: 48.0) { _ in
                        self.drawingAnimations(textView: self.fourthTextView, text: "enables with selected row", x: 179.0, y: 107.0, lenght:  48.0) { _ in
                            self.drawingAnimations(textView: self.fifthTextView, text: "available words to add", x: 179.0, y: 67.0, lenght: 158.0, completionHandler: { _ in })
                        }
                    }
                }
            }
        })
    }
}
