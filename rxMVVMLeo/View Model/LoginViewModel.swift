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
  let service: LeoAPIType
  
  init(coordinator: SceneCoordinatorType, api: LeoAPIType) {
    self.sceneCoordinator = coordinator
    self.service = api
    self.credentialsValid = Driver.of(false)
  }
  
  func login(email: Driver<String>, password: Driver<String>) -> Observable<Void> {
    var accountStatus = Observable.of(AccountStatus.unavailable)
    let data = Driver.combineLatest(email, password)
    data
      .do(onNext: { email, password in
        accountStatus = self.service.login(email: email, password: password)
      })
      .drive()
      .disposed(by: bag)
    
    return accountStatus
      .flatMap { status -> Observable<Void> in
        switch status {
        case .unavailable:
          return Observable.never()
        case .success(_):
          let mainViewModel = MainViewModel.init(coordinator: self.sceneCoordinator, leo: self.service, urban: UrbanAPI.shared)
          return self.sceneCoordinator.transition(to: Scene.main(mainViewModel), type: .show)
            .asObservable().map { _ in }
        }
    }
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
}
