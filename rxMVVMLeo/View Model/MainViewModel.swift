//
//  MainViewModel.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 14/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
  
  let bag = DisposeBag()
  let sceneCoordinator : SceneCoordinatorType
  let serviceLeo : LeoAPIType
  let serviceUrban : UrbanAPIType
  
  init(coordinator: SceneCoordinatorType, leo: LeoAPIType, urban: UrbanAPIType) {
    self.sceneCoordinator = coordinator
    self.serviceLeo = leo
    self.serviceUrban = urban
  }
  
  func meatballs() -> Observable<String> {
    return serviceLeo.getMeatballs()
  }
  
  func logout() {
    let logout = self.serviceLeo.logout()
    logout
      .subscribe(onNext: { state in
        switch state {
        case .unavailable:
          NSApp.terminate(self)
        case .success(_):
          break
        }
      })
      .disposed(by: bag)
  }
  
  func accountInfo() -> Observable<User?> {
    return serviceLeo.accountInfo()
  }

  func writeToDeveloper() {
    return SendEmail.send()
  }
}
