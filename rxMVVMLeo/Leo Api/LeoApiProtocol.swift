//
//  LeoApiProtocol.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 09/05/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift

protocol LeoAPIProtocol {
    func translate(of word: String) -> Observable<[String]>
    func add(a word: String, with translate: String) -> Observable<AddWord>
    func getMeatballs() -> Observable<String>
    func login(email: String, password: String) -> Observable<AccountStatus>
    func logout()
    func accountInfo() -> Observable<User?>
}

