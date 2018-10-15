//
//  SceneCoordinatorType.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 24/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    func pop() -> Completable {
        return pop(animated: true)
    }
}
