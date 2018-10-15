//
//  AppDelegate.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        switch LeoAPI.shared.state.value {
        case .success( _):
            let sceneCoordinator = SceneCoordinator(window: window!)
//            let loginViewModel = LoginViewModel(coordinator: sceneCoordinator, api: LeoAPI.shared)
//            let firstScene = Scene.login(loginViewModel)
//            sceneCoordinator.transition(to: firstScene, type: .root)
            
            let translateViewModel = TranslateViewModel.init(coordinator: sceneCoordinator, leo: LeoAPI.shared, urban: UrbanAPI.shared)
            let secondScene = Scene.translate(translateViewModel)
            sceneCoordinator.transition(to: secondScene, type: .root)
        default:
            let sceneCoordinator = SceneCoordinator(window: window!)
            let loginViewModel = LoginViewModel(coordinator: sceneCoordinator, api: LeoAPI.shared)
            let firstScene = Scene.login(loginViewModel)
            sceneCoordinator.transition(to: firstScene, type: .root)
        }
        
        
        return true
       
        

    }

    

}

