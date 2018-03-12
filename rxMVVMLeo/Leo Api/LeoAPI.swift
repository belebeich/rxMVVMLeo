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
    func login(email: String, password: String) -> Observable<AccessToken>
    func logout()
}

struct LeoAPI : LeoAPIProtocol {
    
    static let shared = LeoAPI()
    
    let status = Variable(AccountStatus.unavailable)
    
    fileprivate enum Address: String {
        case translate = "gettranslates"
        case login = "api/login"
        case logout = "logout"
        
        private var baseURL: String { return "http://api.lingualeo.com/"}
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    func login(email: String, password: String) -> Observable<AccessToken> {
        return Observable.create { observer in
            let parameters : Parameters = ["email":email, "password": password]
            let request = Alamofire.request(Address.login.url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    if let autologin = json["user"]["autologin_key"].string {
                        
                        observer.onNext(autologin)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func logout() {
        _ = Alamofire.request("http://lingualeo.com/logout", method: .post, parameters: [:], encoding: URLEncoding.httpBody, headers: [:])
        
    }
}
