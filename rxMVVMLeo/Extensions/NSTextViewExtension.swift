//
//  NSTextViewExtension.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 10/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import AppKit
import RxSwift

extension NSTextView {
  func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) -> Observable<Bool> {
    
    return Observable.create { observer in
      self.string = ""
      
      var writingTask: DispatchWorkItem?
      writingTask = DispatchWorkItem { [weak weakSelf = self] in
        for character in typedText {
          DispatchQueue.main.async {
            weakSelf?.string.append(character)
          }
          Thread.sleep(forTimeInterval: characterDelay/100)
        }
      }
      
      if let task = writingTask {
        let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
        observer.onNext(true)
        
        queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        
      }
      writingTask?.notify(queue: DispatchQueue.main) {
        
        observer.onNext(false)
      }
      return Disposables.create {
        observer.onNext(true)
      }
      }
      .share()
    //.observeOn(MainScheduler.asyncInstance)
    //.distinctUntilChanged()
    
  }
  
  func setTextWithTypeAnimationSimple(typedText: String, characterDelay: TimeInterval = 5.0, handler: @escaping () -> ()) {
    
    self.string = ""
    
    var writingTask: DispatchWorkItem?
    writingTask = DispatchWorkItem { [weak weakSelf = self] in
      for character in typedText {
        DispatchQueue.main.async {
          weakSelf?.string.append(character)
        }
        Thread.sleep(forTimeInterval: characterDelay/100)
      }
    }
    
    if let task = writingTask {
      let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
      
      queue.asyncAfter(deadline: .now() + 0.05, execute: task)
      
    }
    writingTask?.notify(queue: DispatchQueue.main) {
      
      handler()
    }
  }
}

