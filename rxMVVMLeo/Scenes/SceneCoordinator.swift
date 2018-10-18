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
    
    static func actualViewController(for viewController: NSViewController) -> NSViewController {
        if let windowController = viewController as? NSWindowController {
            return windowController.contentViewController!
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        
        switch type {
            
        case .modal:
//            currentViewController.presentViewControllerAsModalWindow(viewController) {
//                subject.onCompleted()
//            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        case .show:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.contentViewController = viewController
            subject.onCompleted()
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
//    func pop(animated: Bool) -> Completable {
//        let subject = PublishSubject<Void>()
//        if let presenter = currentViewController.presentingViewController {
//            // dismiss a modal controller
//            currentViewController.dismiss(animated: animated) {
//                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
//                subject.onCompleted()
//            }
//        } else if let navigationController = currentViewController.navigationController {
//            // navigate up the stack
//            // one-off subscription to be notified when pop complete
//            _ = navigationController.rx.delegate
//                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
//                .map { _ in }
//                .bind(to: subject)
//            guard navigationController.popViewController(animated: animated) != nil else {
//                fatalError("can't navigate back from \(currentViewController)")
//            }
//            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
//        } else {
//            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
//        }
//        return subject.asObservable()
//            .take(1)
//            .ignoreElements()
//    }
}
