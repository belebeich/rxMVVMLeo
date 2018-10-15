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

//typealias TranslateSection = AnimatableSectionModel<String, String>

struct TranslateViewModel {
    
    
    let bag = DisposeBag()
    let sceneCoordinator : SceneCoordinatorType
    let serviceLeo : LeoAPIProtocol
    let serviceUrban : UrbanAPIProtocol
    
    //Init
    init(coordinator: SceneCoordinatorType, leo: LeoAPIProtocol, urban: UrbanAPIProtocol) {
//        let wordValid = word
//            .distinctUntilChanged()
//            .throttle(0.3)
//            .map { word  -> Bool in
//                var flag = false
//
//                for ch in word.characters {
//                    if ch != " " { flag = true }
//
//                }
//                return flag
//        }
//
//
//
//
        self.sceneCoordinator = coordinator
        self.serviceLeo = leo
        self.serviceUrban = urban
    }
    
    func add(word: String, translate: String) -> Observable<Bool> {
        
        return serviceLeo.add(a: word, with: translate)
    }
    
    func meatballs() -> Observable<String> {
        
        
        return serviceLeo.getMeatballs()
    }
    
    func translate(word: String, translateAPI: Int) -> Observable<[String]> {
        
        var words: Observable<[String]> = Observable.of([])
        
        if translateAPI == 0 {
            words = serviceUrban.translate(of: word)
        } else {
            words = serviceLeo.translate(of: word)
        }
        
        return words
    }
    
    func logout() {
        let loginViewModel = LoginViewModel(coordinator: self.sceneCoordinator, api: self.serviceLeo)
        self.serviceLeo.logout()
        self.sceneCoordinator.transition(to: .login(loginViewModel), type: .modal)
    }
}

