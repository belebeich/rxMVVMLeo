//
//  ViewController.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class LoginViewController: UIViewController, BindableType {

    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
     let bag = DisposeBag()
    
    var viewModel : LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bindUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func bindViewModel() {
        
        emailTextField.text = "appleseedjohnbon@yandex.ru"
        passwordTextField.text = "sbnCV8bmzTb0"
        
        
        
        viewModel.credentialsValidation(email: self.emailTextField.rx.text.orEmpty.asDriver(), password: self.passwordTextField.rx.text.orEmpty.asDriver())
            .drive(onNext: { [unowned self] valid in
                self.loginButton.isEnabled = valid
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
            .withLatestFrom(viewModel.credentialsValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid in
                self.viewModel.login(email: self.emailTextField.rx.text.orEmpty.asDriver(), password: self.passwordTextField.rx.text.orEmpty.asDriver())
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
    }

//    func bindUI() {
//        let viewModel = LoginViewModel.init(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver())
//        emailTextField.text = "appleseedjohnbon@yandex.ru"
//        passwordTextField.text = "sbnCV8bmzTb0"
//
//        viewModel.credentialsValid
//            .drive(onNext: { [unowned self] valid in
//                self.loginButton.isEnabled = valid
//            })
//            .disposed(by: bag)
//
//        loginButton.rx.tap
//            .withLatestFrom(viewModel.credentialsValid)
//            .filter { $0 }
//            .flatMapLatest { [unowned self] valid in
//                viewModel.login(email: self.emailTextField.text!, password: self.passwordTextField.text!)
//                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
//            }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] authStatus in
//
//
//                switch authStatus {
//                case .unavailable:
//
//                    break
//                case .success(let value):
//                    self.tokenLabel.text = value
//                }
//
//                LeoAPI.shared.state.value = authStatus
//
//
//
//            })
//            .disposed(by: bag)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

