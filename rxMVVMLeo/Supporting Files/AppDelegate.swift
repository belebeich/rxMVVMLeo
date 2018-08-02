//
//  AppDelegate.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 05/03/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        switch LeoAPI.shared.state.value {
        case .success( _):
            let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue:"Main"), bundle: nil)
            let homeViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "TranslateViewController")) as! TranslateViewController
            NSApp.keyWindow?.contentViewController = homeViewController
        default:
            let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue:"Main"), bundle: nil)
            let homeViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginViewController")) as! LoginViewController
            NSApp.keyWindow?.contentViewController = homeViewController
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

