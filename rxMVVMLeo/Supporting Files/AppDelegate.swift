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
  
  var window : NSWindow?
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue:"Main"), bundle: nil)
    
    switch LeoAPI.shared.state.value {
    case .success( _):
      let wc = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainWindowController")) as! NSWindowController
      window = wc.window
      let sceneCoordinator = SceneCoordinator(window: window!)
      let mainViewModel = MainViewModel.init(coordinator: sceneCoordinator, leo: LeoAPI.shared, urban: UrbanAPI.shared)
      let secondScene = Scene.main(mainViewModel)
      sceneCoordinator.transition(to: secondScene, type: .show)
      wc.showWindow(self)
      
    case .unavailable:
      let wc = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LoginWindowController")) as! NSWindowController
      window = wc.window
      let sceneCoordinator = SceneCoordinator(window: window!)
      let loginViewModel = LoginViewModel.init(coordinator: sceneCoordinator, api: LeoAPI.shared)
      let firstScene = Scene.login(loginViewModel)
      sceneCoordinator.transition(to: firstScene, type: .show)
      wc.showWindow(self)
    }
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  
}

