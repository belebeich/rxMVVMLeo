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
import Quartz

class MainViewController: NSViewController {
    
    let bag = DisposeBag()

   
    @IBOutlet var firstTextView: NSTextView!
    @IBOutlet var secondTextView: NSTextView!
    
    @IBOutlet var thirdTextView: NSTextView!
    @IBOutlet var fourthTextView: NSTextView!
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
        
        
    }
    
    
    

    func setUI() {
        let neonyellowColor = NSColor.init(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
        let mainFont = NSFont.init(name: "PFDinMono-Regular", size: 13)
        let tipsFont = NSFont.init(name: "PFDinMono-Regular", size: 12)
        
        self.menuButtonView.isHidden = true
        self.menuBarImageView.isHidden = true
        self.notificationCenterImageView.isHidden = true
        
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
    
    func bindUI() {
        
        
        accountButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tabView.selectTabViewItem(at: 0)
                
            })
            .disposed(by: bag)
        
        helpButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.tabView.selectTabViewItem(at: 1)
            })
            .disposed(by: bag)
        
        
        helpButton.rx.tap
            .take(1)
            .subscribe(onNext: { [unowned self] _ in
                self.helpTab()
            })
            .disposed(by: bag)
        
        
        
//        let viewModel = TranslateViewModel.init(word: wordTextField.rx.text.orEmpty.asDriver())
//        self.addWordButton.isEnabled = false
//        let translateResults = wordTextField.rx.text.orEmpty
//            .throttle(0.3, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { query -> Observable<[String]> in
//                if query.isEmpty {
//                    self.addWordButton.isEnabled = false
//                    return .just([])
//                } else {
//                    self.addWordButton.isEnabled = true
//                    self.searchIndicator.isHidden = false
//                    self.searchIndicator.startAnimation(self)
//                    return viewModel.translate(word: query, translateAPI: 0)
//                }
//            }
//            .do(onNext: { _ in
//                self.searchIndicator.stopAnimation(self)
//                self.searchIndicator.isHidden = true
//            })
//            .observeOn(MainScheduler.instance)
//        
//        
//        translateResults
//            .bind(to: translateTextField.rx.text)
//            .disposed(by: bag)
        
        
        
//        addWordButton.rx.tap
//            .subscribe({ [unowned self] _ in
//                
//                viewModel.add(word: self.wordTextField.stringValue, translate: self.translateTextField.string)
//                    .map { result in
//                        if result == true {
//                            viewModel.meatballs()
//                                .bind(to: self.availableWordsLabel.rx.text)
//                                .disposed(by: self.bag)
//                        }
//                        return result
//                    }
//                    .asDriver(onErrorJustReturn: false)
//                    .drive(self.addWordButton.rx.isEnabled)
//                    .disposed(by: self.bag)
//                
//                
//            })
//            .disposed(by: bag)
        
//        logoutButton.rx.tap
//            .subscribe(onNext: {
//                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("logoutSegue"), sender: self)
//                viewModel.logout()
//            })
//            .disposed(by: bag)
//
//        viewModel.meatballs()
//            .bind(to: availableWordsLabel.rx.text)
//            .disposed(by: bag)
//
    
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.view.window?.close()
    }
    
}


extension MainViewController {
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    private func drawingAnimations(textView: NSTextView, text: String, x: Double, y: Double, completionHandler: @escaping CompletionHandler) {
        
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
                    
                    pt.line(to: CGPoint(x: x+48, y: y))
                    
                    line.path = pt.cgPath
                    
                    CATransaction.begin()
                    
                    let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
                    pathAnimation.duration = 0.5
                    pathAnimation.fromValue = 0.0
                    pathAnimation.toValue = 1.0
                    pathAnimation.fillMode = kCAFillModeForwards
                    pathAnimation.autoreverses = false
                    line.strokeEnd = 1.0
                    
                    CATransaction.setCompletionBlock { [unowned self] in
                        completionHandler(true)
//                        let secondTextView = self.secondTextView.setTextWithTypeAnimation(typedText: "Words input", characterDelay: 5.0)
//
//                        secondTextView
//                            .subscribe(onNext: { [unowned self] bool in
//                                if bool == false {
//                                    print("ok")
//                                }
//                            })
//                            .disposed(by: self.bag)
                        
                    }
                    
                    line.add(pathAnimation, forKey: "path")
                    //self.view.layer?.addSublayer(line)
                    self.tabView.selectedTabViewItem?.view?.layer?.addSublayer(line)
                    CATransaction.commit()
                }
            })
            .disposed(by: bag)
        
        
        
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: { [unowned self] in
            self.drawingAnimations(textView: self.firstTextView, text: "translate options", x: 170.0, y: 196.0) { _ in
                self.drawingAnimations(textView: self.secondTextView, text: "words input", x: 170, y: 165.0) {_ in
                    self.drawingAnimations(textView: self.thirdTextView, text: "translates table will appear here", x: 170.0, y: 125) { _ in
                        self.drawingAnimations(textView: self.fourthTextView, text: "enables with selected row", x: 170.0, y: 105.0) { _ in
                            print("ok")
                        }
                    }
                }
            }
//            let firstTextView = self.firstTextView.setTextWithTypeAnimation(typedText: "Translate options", characterDelay: 5.0)
//
//            firstTextView
//                .subscribe(onNext: { [unowned self] bool in
//                    if bool == false {
//                        self.drawingAnimations(with: 199.0, and: 265.0)
//                    }
//                })
//                .disposed(by: self.bag)
        })
    }
}
