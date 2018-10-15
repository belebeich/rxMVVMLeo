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
    
    var credentialsValid : Driver<Bool>
    
    let sceneCoordinator: SceneCoordinatorType
    let service: LeoAPIProtocol
    
    init(coordinator: SceneCoordinatorType, api: LeoAPIProtocol) {
        
        self.sceneCoordinator = coordinator
        self.service = api
        self.credentialsValid = Driver.of(false)
    }
    
    mutating func credentialsValidation(email: Driver<String>, password: Driver<String>) -> Driver<Bool> {
        let emailValid = email
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 3 }
        
        let passwordValid = password
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 3 }
        
        credentialsValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
        return credentialsValid
    }
    
    func login(email: Driver<String>, password: Driver<String>) -> Observable<Void> {
        
        var accountStatus = Observable.of(AccountStatus.unavailable)
        
       
        let os = Driver.combineLatest(email, password)
        
        os
            .throttle(0.3)
            .do(onNext: { email, password in
                accountStatus = self.service.login(email: email, password: password)
                
            })
            .drive()
            .disposed(by: bag)
        
        return accountStatus
            .flatMap { status -> Observable<Void> in
                switch status {
                case .unavailable:
                    print("unvlbl")
                    return Observable.never()
                    
                case .success(_):
                    print("success")
                    let translateViewModel = TranslateViewModel.init(coordinator: self.sceneCoordinator, leo: self.service, urban: UrbanAPI.shared)
                    return self.sceneCoordinator.transition(to: Scene.translate(translateViewModel), type: .modal)
                        .asObservable().map { _ in }
                    
                }
        }
    }
}

