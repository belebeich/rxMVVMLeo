//
//  NSSegmentedConrol+Rx.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 23/08/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
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
    
}

