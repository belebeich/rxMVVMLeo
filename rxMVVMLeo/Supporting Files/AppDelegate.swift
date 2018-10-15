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

    var window : NSWindowController!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        switch LeoAPI.shared.state.value {
        case .success( _):
            
            let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue:"Main"), bundle: nil)
            window = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainWindowController")) as! NSWindowController
            let homeViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "TranslateViewController")) as! MainViewController
            
            window.contentViewController = homeViewController
            window.showWindow(self)
            
        case .unavailable:
            
            let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue:"Main"), bundle: nil)
            window = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginWindowController")) as! NSWindowController
            let homeViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginViewController")) as! LoginViewController

            window.contentViewController = homeViewController
            
            window.showWindow(self)
            
            
//            let windowController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "WindowController")) as! NSWindowController
//
//            windowController.window?.makeKeyAndOrderFront(nil)
//
//            NSApp.keyWindow?.windowController = windowController
//            windowController.showWindow(self)
            
            //let homeViewController = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginViewController")) as! LoginViewController
            
//            let window = NSWindow(contentViewController: homeViewController)
//            NSApp.activate(ignoringOtherApps: true)
//            window.makeKeyAndOrderFront(self)
//            let wc = NSWindowController(window: window)
//            wc.showWindow(self)
            //NSApp.keyWindow?.contentViewController = homeViewController
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

