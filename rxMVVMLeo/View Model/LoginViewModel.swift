//
//  LoginViewModel.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


struct LoginViewModel {
    
    private let bag = DisposeBag()
    
    let credentialsValid: Driver<Bool>
    
    //Input
    //var email = Variable<String>("")
    //var password = Variable<String>("")
    
    //Output
    var token = Variable<String?>("")
    
    init(email: Driver<String>, password: Driver<String>) {
        
        let emailValid = email
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 3 }
        
        let passwordValid = password
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 3 }
        
        credentialsValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
        
        
    }
    
    func login(email: String, password: String) -> Observable<AccountStatus> {
        
        return LeoAPI.shared.login(email: email, password: password)
    }
    
    func logout() {
        return LeoAPI.shared.logout()
    }
    
    func bindOutput() {
//        let account = LeoAPI.init()
//        
//        
//        account.login(email: email.value, password: password.value)
//            .distinctUntilChanged()
//            .bind(to: token)
//            .disposed(by: bag)
//    }
    }
}
