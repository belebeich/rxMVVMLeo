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

protocol LoginViewModelProtocol {
  var email: BehaviorRelay<String> { get }
  var password: BehaviorRelay<String> { get }
  var credentialsValid: BehaviorRelay<Bool> { get }
  var loginInitiated: BehaviorRelay<Bool> { get }
  var signedIn: BehaviorRelay<Bool> { get }
}

final class LoginViewModel: LoginViewModelProtocol {
  
  var email: BehaviorRelay<String>
  var password: BehaviorRelay<String>
  var credentialsValid: BehaviorRelay<Bool>
  var loginInitiated: BehaviorRelay<Bool>
  var signedIn: BehaviorRelay<Bool>
  
  private var accountStatus: BehaviorRelay<AccountStatus>
  
  private let sceneCoordinator: SceneCoordinatorType
  private let service: LeoAPIType
  private let disposeBag = DisposeBag()
  
  init(coordinator: SceneCoordinatorType, api: LeoAPIType) {
    self.sceneCoordinator = coordinator
    self.service = api
    self.email = BehaviorRelay(value: "")
    self.password = BehaviorRelay(value: "")
    self.credentialsValid = BehaviorRelay(value: false)
    self.loginInitiated = BehaviorRelay(value: false)
    self.signedIn = BehaviorRelay(value: false)
    self.accountStatus = BehaviorRelay(value: .unavailable)
    
    bind()
  }
  
  private func bind() {
    Observable.combineLatest(email, password, loginInitiated)
      .filter { $2 == true }
      .flatMapLatest { [weak self] email, password, _ -> Observable<AccountStatus> in
        guard let self = self else { return .just(.unavailable) }
        return self.service.login(email: email, password: password)
      }
      .bind(to: accountStatus)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(email, password)
      .flatMapLatest { email, password -> Observable<Bool> in
        return .just(email.utf8.count > 3 && password.utf8.count > 3)
      }
      .bind(to: credentialsValid)
      .disposed(by: disposeBag)
    
    accountStatus
      .flatMapLatest { status -> Observable<Bool> in
        switch status {
        case .unavailable:
          return .just(false)
        case .success(_):
          return .just(true)
        }
      }
      .bind(to: signedIn)
      .disposed(by: disposeBag)
    
    signedIn
      .filter { $0 == true }
      .bind { [weak self] _ in
        guard let self = self else { return }
        let mainViewModel = MainViewModel.init(coordinator: self.sceneCoordinator, leo: self.service, urban: UrbanAPI.shared)
        self.sceneCoordinator.transition(to: Scene.main(mainViewModel), type: .show)
      }
      .disposed(by: disposeBag)
    
  }
//  func login(email: Driver<String>, password: Driver<String>) -> Observable<Bool> {
//    var accountStatus = Observable.of(AccountStatus.unavailable)
//    let data = Driver.combineLatest(email, password)
//    data
//      .do(onNext: { email, password in
//        accountStatus = self.service.login(email: email, password: password)
//      })
//      .drive()
//      .disposed(by: bag)
//
//    return accountStatus
//      .flatMap { status -> Observable<Bool> in
//        switch status {
//        case .unavailable:
//          return Observable.of(false)
//        case .success(_):
//          let mainViewModel = MainViewModel.init(coordinator: self.sceneCoordinator, leo: self.service, urban: UrbanAPI.shared)
//          self.sceneCoordinator.transition(to: Scene.main(mainViewModel), type: .show)
//          return Observable.of(true)
//        }
//    }
//  }
//
//
//  mutating func credentialsValidation(email: Driver<String>, password: Driver<String>) -> Driver<Bool> {
//    let emailValid = email
//      .distinctUntilChanged()
//      .throttle(0.3)
//      .map { $0.utf8.count > 3 }
//
//    let passwordValid = password
//      .distinctUntilChanged()
//      .throttle(0.3)
//      .map { $0.utf8.count > 3 }
//
//    credentialsValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
//    return credentialsValid
//  }
}
