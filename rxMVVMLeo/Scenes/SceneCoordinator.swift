//
//  SceneCoordinator.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 02/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxSwift

class SceneCoordinator: SceneCoordinatorType {
  var window: NSWindow
  var currentViewController: NSViewController
  
  required init(window: NSWindow) {
    self.window = window
    currentViewController = window.contentViewController!
  }
  
  static func actualViewController(for viewController: NSWindowController) -> NSViewController {
    return viewController.contentViewController!
  }
  
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
    let subject = PublishSubject<Void>()
    let windowController = scene.viewController()
    switch type {
    case .modal:
      let viewController = SceneCoordinator.actualViewController(for: windowController)
      currentViewController.presentViewControllerAsModalWindow(viewController)
      subject.onCompleted()
      currentViewController = SceneCoordinator.actualViewController(for: windowController)
    case .show:
      window.contentViewController = windowController.contentViewController
      currentViewController = SceneCoordinator.actualViewController(for: windowController)
      subject.onCompleted()
    }
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }
}
