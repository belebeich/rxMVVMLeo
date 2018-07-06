//
//  LeoAPI.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift
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
    enum Keys {
        static let token = "token"
        static let points = "meatballs"
        static let cookies = "cookies"
    }
    
    fileprivate enum Address: String {
        case translate = "gettranslates"
        case login = "api/login"
        case logout = "logout"
        case addword = "addword"
        
        private var baseURL: String { return "http://api.lingualeo.com/"}
        private var mainURL : String { return "http://lingualeo.com/" }
        
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
    
    var state: Variable<AccountStatus> {
        if let storedToken = UserDefaults.standard.string(forKey: Keys.token) {
            return Variable(AccountStatus.success(storedToken))
        } else {
            return Variable(AccountStatus.unavailable)
        }
    }
    
    var meatballs: Variable<Int> {
        guard let points = UserDefaults.standard.object(forKey: Keys.points) as? Int else { return Variable(0) }
        return Variable(points)
     }
    
    func login(email: String, password: String) -> Observable<AccountStatus> {
        
        let params = ["email": email,
                      "password" : password]
        
        let response : Observable<JSON> = request(address: LeoAPI.Address.login, parameters: params)
        
        return response
            .map { result in
                
                if let autologin = result["user"]["autologin_key"].string {
                    UserDefaults.standard.setValue(autologin, forKeyPath: Keys.token)
                    
                    if let meatballs = result["user"]["meatballs"].int {
                        UserDefaults.standard.setValue(meatballs, forKey: Keys.points)
                    }
                    
                    guard let cookies = HTTPCookieStorage.shared.cookies else { return AccountStatus.unavailable }
                    
                    
                    let data = NSKeyedArchiver.archivedData(withRootObject: cookies)
                    self.keychain.set(data, forKey: "cookies")
                    
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
    
    func add(a word: String, with translate: String) {
        let params = ["word": word,
                      "tword": translate]
        
        guard let data = self.keychain.getData("cookies") else { return }
        guard let cookies = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HTTPCookie] else { return }
        
        for cookie in cookies {
            Alamofire.HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        let response = Alamofire.request(LeoAPI.Address.addword.url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
        response
            .response { result in
                guard let json = try? JSON(result.data!) else { return }
                print(json)
        }
    }
    
    func logout() {
        let requester = Alamofire.request(LeoAPI.Address.logout.url, method: .post, parameters: [:], encoding: URLEncoding.httpBody, headers: [:])
        requester
            .response {_ in
                
                self.state.value = .unavailable
                UserDefaults.standard.removeObject(forKey: Keys.token)
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
