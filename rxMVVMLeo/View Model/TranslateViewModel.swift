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
    
    var segment: BehaviorRelay<Int> {
        if let segment = UserDefaults.standard.value(forKey: "segment") as? Int {
            return BehaviorRelay(value: segment)
        } else {
            return BehaviorRelay(value: 1)
        }
    }
    
    func setTranslateOptions(with segm: Driver<Int>) {
        
        segm.asObservable()
            .subscribe(onNext: { seg in
                UserDefaults.standard.set(seg, forKey: "segment")
            })
            .disposed(by: bag)
        
    }
    
    func add(word: String, translate: String) -> Observable<AddWord> {
        
        return LeoAPI.shared.add(a: word, with: translate)
    }
    
    func meatballs() -> Observable<String> {
        return LeoAPI.shared.getMeatballs()
    }
    
    func translate(word: String, translateAPI: Int) -> Observable<[String]> {
        
        var words: Observable<[String]> = Observable.of([])
        
        if translateAPI == 0 {
            words = UrbanAPI.shared.translate(of: word)
        } else {
            words = LeoAPI.shared.translate(of: word)
        }
//        let stroke = words
//            .flatMap { words -> Observable<[String]> in
//                return Observable.of(words)
//        }
//        return stroke
        return words
    }
    
    
    
    
}
