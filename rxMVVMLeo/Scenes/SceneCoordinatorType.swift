//
//  SceneCoordinatorType.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 02/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxSwift

protocol SceneCoordinatorType {
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    //func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    //    func pop() -> Completable {
    //        return pop(animated: true)
    //    }
}
