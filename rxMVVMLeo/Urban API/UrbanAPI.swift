//
//  UrbanAPI.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 29/07/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

struct UrbanAPI: UrbanAPIType {
  
  static let shared = UrbanAPI()
  
  fileprivate enum Address: String {
    
    case word = "/v0/define?term="
    
    private var baseURL: String { return "http://api.urbandictionary.com"}
    
    var url: URL {
      return URL(string: baseURL.appending(rawValue))!
    }
  }
  
  func translate(of word: String) -> Observable<[String]> {
    
    let urlString = "https://api.urbandictionary.com/v0/define?term=\(word)"
    
    let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    guard let url = URL(string: encodedURLString!) else { return Observable.of([])}
    
    let response : Observable<JSON> = request(address: url)
    
    return response
      .map{ result in
        var translates = [String]()
        guard let list = result["list"].array else { return []}
        for element in list {
          if let parsed = element["definition"].string {
            translates.append(parsed)
          }
        }
        return translates
    }
  }
  
  //MARK: - generic request
  private func request<T:Any>(address: URL) -> Observable<T> {
    return Observable.create { observer in
      let request = Alamofire.request(address,
                                      method: .get,
                                      parameters: [:],
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
