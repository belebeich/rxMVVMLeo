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
import KeychainSwift

typealias AccessToken = String

enum AccountStatus {
    case unavailable
    case success(AccessToken)
}

struct LeoAPI : LeoAPIProtocol {
    
    //Types
    fileprivate enum Keys {
        static let token = "token"
        static let points = "meatballs"
        static let cookies = "cookies"
    }
    
    fileprivate enum Address: String {
        case translate = "gettranslates"
        case login = "api/login"
        case logout = "logout"
        case addword = "addword"
        
        private var baseURL: String { return "https://api.lingualeo.com/"}
        private var mainURL : String { return "https://lingualeo.com/" }
        
        var url: URL {
            switch self {
            case .logout:
                return URL(string: mainURL.appending(rawValue))!
            default:
                return URL(string: baseURL.appending(rawValue))!
            }
        }
    }
    
    fileprivate enum Errors: Error {
        case requestFailed
    }
    
    //Properties
    static var shared = LeoAPI()
    
    private let keychain = KeychainSwift()
    
    var state: BehaviorRelay<AccountStatus> {
        if let storedToken = self.keychain.get(Keys.token) {
            return BehaviorRelay(value: AccountStatus.success(storedToken))
        } else {
            return BehaviorRelay(value: AccountStatus.unavailable)
        }
    }
    
    func login(email: String, password: String) -> Observable<AccountStatus> {
        
        let params = ["email": email,
                      "password" : password]
        
        let response : Observable<JSON> = request(address: LeoAPI.Address.login, parameters: params)
        
        return response
            .map { result in
                
                if let autologin = result["user"]["autologin_key"].string {
                    
                    self.keychain.set(autologin, forKey: Keys.token)
                    if let meatballs = result["user"]["meatballs"].int {
                        UserDefaults.standard.setValue(meatballs, forKey: Keys.points)
                    }
                    
                    guard let cookies = HTTPCookieStorage.shared.cookies else { return AccountStatus.unavailable }
                
                    let data = NSKeyedArchiver.archivedData(withRootObject: cookies)
                    self.keychain.set(data, forKey: Keys.cookies)
                    
                    return AccountStatus.success(autologin)
                } else {
                    return AccountStatus.unavailable
                }
            }
        
        
    }
    
    func translate(of word: String) -> Observable<[String]> {
        
        let params = ["word":word]
        
        let response : Observable<JSON> = request(address: LeoAPI.Address.translate, parameters: params)
        
        return response
            .map { result in
                var translates = [String]()
                guard let words = result["translate"].array else { return [] }
                for word in words {
                    if let parsed = word["value"].string {
                        translates.append(parsed)
                    }
                }
                return translates
        }
        
    }
    
    func add(a word: String, with translate: String) -> Observable<Bool> {
        guard let data = self.keychain.getData(Keys.cookies) else {  return Observable.of(true) }
        guard let cookies = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HTTPCookie] else { return Observable.of(true) }
        
        for cookie in cookies {
            Alamofire.HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        let params = ["word": word,
                      "tword": translate]
        
        return Observable.create { observer in
            let response = Alamofire.request(LeoAPI.Address.addword.url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            response
                .responseJSON { response in
                    switch response.result {
                    case .success(_):
                        observer.onNext(false)
                        observer.onCompleted()
                    case .failure(_):
                        observer.onNext(true)
                    }
            }
            return Disposables.create {
                observer.onNext(true)
            }
        }
    }
    
    func getMeatballs() -> Observable<String> {
        
        guard let data = self.keychain.getData(Keys.cookies) else { return  Observable.of("")}
        guard let cookies = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HTTPCookie] else { return Observable.of("")}
        
        for cookie in cookies {
            Alamofire.HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        switch LeoAPI.shared.state.value {
            case .success(_):
                let response : Observable<JSON> = request(address: LeoAPI.Address.login)
                return response
                    .map { result in
                        
                        if let words = result["user"]["meatballs"].int {
                            
                            return "\(words)"
                        } else {
                            return ""
                        }
                    }
            
            case .unavailable:
                return Observable.of("")
        }
        
    }
    
    func logout() {
        let requester = Alamofire.request(LeoAPI.Address.logout.url, method: .post, parameters: [:], encoding: URLEncoding.httpBody, headers: [:])
        requester
            .response {_ in
                
                self.state.accept(.unavailable)
                self.keychain.delete(Keys.cookies)
                self.keychain.delete(Keys.token)
                self.keychain.clear()
        }
        
    }
    
    //MARK: - generic request
    private func request<T:Any>(address: Address, parameters: [String:String] = [:]) -> Observable<T> {
        return Observable.create { observer in
            
            let request = Alamofire.request(address.url,
                                            method: .post,
                                            parameters: parameters,
                                            encoding: URLEncoding.httpBody,
                                            headers: [:])
            
            request.responseJSON { response in
                guard response.error == nil, let data = response.data, let result = JSON(data) as? T else { return }
                
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    
}
