//
//  MainViewModel.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 14/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import RxSwift
import RxCocoa

protocol MainViewModelProtocol {
  var meatballs: BehaviorRelay<String> { get }
  var write: BehaviorRelay<Bool> { get }
  var user: BehaviorRelay<User?> { get }
  var loggedOut: BehaviorRelay<Bool> { get }
}

struct MainViewModel: MainViewModelProtocol {
  
  var meatballs: BehaviorRelay<String>
  var write: BehaviorRelay<Bool>
  var user: BehaviorRelay<User?>
  var loggedOut: BehaviorRelay<Bool>
  
  private let sceneCoordinator : SceneCoordinatorType
  private let serviceLeo : LeoAPIType
  private let serviceUrban : UrbanAPIType
  private let disposeBag = DisposeBag()
  
  init(coordinator: SceneCoordinatorType, leo: LeoAPIType, urban: UrbanAPIType) {
    self.sceneCoordinator = coordinator
    self.serviceLeo = leo
    self.serviceUrban = urban
    self.meatballs = BehaviorRelay(value: "")
    self.write = BehaviorRelay(value: false)
    self.user = BehaviorRelay(value: nil)
    self.loggedOut = BehaviorRelay(value: false)
    
    bind()
  }
  
  private func bind() {
    serviceLeo.getMeatballs()
      .bind(to: meatballs)
      .disposed(by: disposeBag)
    
    serviceLeo.accountInfo()
      .bind(to: user)
      .disposed(by: disposeBag)
    
    loggedOut
      .filter { $0 == true }
      .flatMap { _ -> Observable<AccountStatus> in
        return self.serviceLeo.logout()
      }
      .bind { state in
        switch state {
        case .unavailable:
          NSApp.terminate(self)
        case .success(_):
          break
        }
      }
      .disposed(by: disposeBag)
    
    write
      .filter { $0 == true }
      .bind { _ in
        SendEmail.send()
      }
      .disposed(by: disposeBag)
  }
}
