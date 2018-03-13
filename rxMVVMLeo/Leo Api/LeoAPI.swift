//
//  LeoAPI.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

typealias AccessToken = String

enum AccountStatus {
    case unavailable
    
    case success(AccessToken)
}



protocol LeoAPIProtocol {
    //func translate(of word: String) -> Observable<JSON>
    func login(email: String, password: String) -> Observable<AccountStatus>
    func logout()
}

struct LeoAPI : LeoAPIProtocol {
    
    static var shared = LeoAPI()
    
    //var status = Variable(AccountStatus.unavailable)
    
    var state: Variable<AccountStatus> {
        if let storedToken = UserDefaults.standard.string(forKey: "token") {
            return Variable(AccountStatus.success(storedToken))
        } else {
            return Variable(AccountStatus.unavailable)
        }
    }
    
//    var state: AccountStatus {
//
//        get {
//            if let storedToken = UserDefaults.standard.string(forKey: "token") {
//                return AccountStatus.success(storedToken)
//            } else {
//                return AccountStatus.unavailable
//            }
//        }
//        set {
//            state = .unavailable
//        }
//    }
    
    fileprivate enum Address: String {
        case translate = "gettranslates"
        case login = "api/login"
        case logout = "logout"
        
        private var baseURL: String { return "http://api.lingualeo.com/"}
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    func login(email: String, password: String) -> Observable<AccountStatus> {
        return Observable.create { observer in
            let parameters : Parameters = ["email":email, "password": password]
            let request = Alamofire.request(Address.login.url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    if let autologin = json["user"]["autologin_key"].string {
                        UserDefaults.standard.set(autologin, forKey: "token")
                        observer.onNext(.success(autologin))
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onNext(.unavailable)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func logout() {
        state.value = .unavailable
        print(state.value)
        UserDefaults.standard.removeObject(forKey: "token")
        _ = Alamofire.request("http://lingualeo.com/logout", method: .post, parameters: [:], encoding: URLEncoding.httpBody, headers: [:])
        
    }
}
