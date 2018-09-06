//
//  TranslateViewModel.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 13/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

struct TranslateViewModel {
    
    var inputValid: Driver<Bool>
    let bag = DisposeBag()
    
    
    //Init
    init(word: Driver<String>) {
        let wordValid = word
            .distinctUntilChanged()
            .throttle(0.3)
            .map { word  -> Bool in
                var flag = false
                
                for ch in word.characters {
                    if ch != " " { flag = true }
                    
                }
                return flag
        }
        
        
        
        
        inputValid = wordValid
        
        
    }
    
    func add(word: String, translate: String) {
        
        return LeoAPI.shared.add(a: word, with: translate)
    }
    
    func meatballs() -> Observable<String> {
        
        
        return LeoAPI.shared.getMeatballs()
    }
    
    func translate(word: String, translateAPI: Int) -> Observable<[String]> {
        
        var words: Observable<[String]> = Observable.of([])
        
//        translateAPI.asObservable()
//            .subscribe(onNext: { api in
//                if api == 0 {
//                    words = UrbanAPI.shared.translate(of: word)
//                } else {
//                    words = LeoAPI.shared.translate(of: word)
//                }
//            })
//            .disposed(by: bag)
        
        if translateAPI == 0 {
            words = UrbanAPI.shared.translate(of: word)
        } else {
            words = LeoAPI.shared.translate(of: word)
        }
        
        
        
        //        let words = UrbanAPI.shared.translate(of: word)
        //
                let stroke = words
                    .flatMap { words -> Observable<[String]> in
        
                        return Observable.of(words)
                    }
        return stroke
        
    }
    
    func logout() {
        return LeoAPI.shared.logout()
    }
}
