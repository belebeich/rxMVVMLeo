//
//  NSSegmentedConrol+Rx.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 23/08/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

extension Reactive where Base: NSSegmentedControl {
  
  /// Reactive wrapper for `selectedSegmentIndex` property.
  public var selectedSegmentIndex: ControlProperty<Int> {
    return value
  }
  
  /// Reactive wrapper for `selectedSegmentIndex` property.
  public var value: ControlProperty<Int> {
    return base.rx.controlProperty(
      getter: { segmentedControl in
        segmentedControl.selectedSegment
    }, setter: { segmentedControl, value in
      segmentedControl.selectedSegment = value
    }
    )
  }
  
  /// Reactive wrapper for `setEnabled(_:forSegment:)`
  public func enabledForSegment(at index: Int) -> Binder<Bool> {
    return Binder(self.base) { (segmentedControl, segmentEnabled) -> () in
      segmentedControl.setEnabled(segmentEnabled, forSegment: index)
    }
  }
  
  /// Reactive wrapper for `setTitle(_:forSegment:)`
  public func titleForSegment(at index: Int) -> Binder<String?> {
    return Binder(self.base) { (segmentedControl, label) -> () in
      segmentedControl.setLabel(label ?? "", forSegment: index)
    }
  }
  
  /// Reactive wrapper for `setImage(_:forSegment:)`
  public func imageForSegment(at index: Int) -> Binder<NSImage?> {
    return Binder(self.base) { (segmentedControl, image) -> () in
      segmentedControl.setImage(image, forSegment: index)
    }
  }
}


