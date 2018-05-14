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

typealias AccessToken = String

enum AccountStatus {
    case unavailable
    case success(AccessToken)
}

struct LeoAPI : LeoAPIProtocol {
    
    //Constants
    private let token = "token"
    
    static var shared = LeoAPI()
    
    var state: Variable<AccountStatus> {
        if let storedToken = UserDefaults.standard.string(forKey: token) {
            return Variable(AccountStatus.success(storedToken))
        } else {
            return Variable(AccountStatus.unavailable)
        }
    }
    
    fileprivate enum Address: String {
        case translate = "gettranslates"
        case login = "api/login"
        case logout = "logout"
        
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
    
    func login(email: String, password: String) -> Observable<AccountStatus> {
        return Observable.create { observer in
            let parameters : Parameters = ["email":email, "password": password]
            let request = Alamofire.request(Address.login.url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON {
                response in
                switch response.result {
                case .success(let value):

                    let json = JSON(value)
                    
                    if let autologin = json["user"]["autologin_key"].string {
                        UserDefaults.standard.set(autologin, forKey: self.token)
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
    
    func translation(of word: String) -> Observable<[String]> {
        
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
    
    func translate(of word: String) -> Observable<String> {
        return Observable.create { observer in
            let params: Parameters = ["word": word]
            let request = Alamofire.request(Address.translate.url,
                                            method: .post,
                                            parameters: params,
                                            encoding: URLEncoding.httpBody,
                                            headers: [:])
            request.responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let translate = json["translate"].array?.first?["value"].string else { observer.onNext(""); observer.onCompleted(); return}
                    observer.onNext(translate)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onNext("")
                }
            }
            return Disposables.create {
                request.cancel()
            }
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
                guard response.error == nil, let data = response.data, let json = try? JSON(data) as? T, let result = json else {
                    observer.onError(Errors.requestFailed);
                    return
                }
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func logout() {
        state.value = .unavailable
        UserDefaults.standard.removeObject(forKey: token)
        _ = Alamofire.request(Address.logout.url,
                              method: .post,
                              parameters: [:],
                              encoding: URLEncoding.httpBody,
                              headers: [:])
    }
}
