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
    
    func translate(word: String) -> Observable<String> {
        let words = LeoAPI.shared.translate(of: word)
        
        let stroke = words
            .flatMap { words -> Observable<String> in
                let text = Observable.of(words.joined(separator: ", "))
                return text
            }
        
        return stroke
    }
    
    
    func logout() {
        return LeoAPI.shared.logout()
    }
}
