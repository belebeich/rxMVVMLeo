//
//  Scene+ViewController.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 02/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

extension Scene {
    func viewController() -> NSViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        switch self {
        case .login(let viewModel):
            let wc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginWindowController")) as! NSWindowController

            let vc = wc.contentViewController as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return wc
            
        case .main(let viewModel):
            let wc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainWindowController")) as! NSWindowController
            
            let vc = wc.contentViewController as! MainViewController
            vc.bindViewModel(to: viewModel)
            return wc
        }
    }
}
