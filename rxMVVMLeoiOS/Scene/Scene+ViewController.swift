//
//  Scene+ViewController.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 24/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .login(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            var vc = nc.viewControllers.first as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return nc
            
        case .translate(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Translate") as! UINavigationController
            var vc = nc.viewControllers.first as! TranslateViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
