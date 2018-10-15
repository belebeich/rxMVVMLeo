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
    func accountInfo() -> Observable<User?> {
        return LeoAPI.shared.accountInfo()
    }
    
    func logout() {
        return LeoAPI.shared.logout()
    }
    
    func writeToDeveloper() {
        return SendEmail.send()
    }
}
