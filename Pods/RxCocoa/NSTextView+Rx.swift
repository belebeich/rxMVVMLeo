//
//  NSTextView+Rx.swift
//  RxCocoa-macOS
//
//  Created by Ivan  on 14/05/2018.
//

import Foundation

//
//  NSTextView+Rx.swift
//  RxCocoa
//
//  Created by Tal Shrestha on 5/8/17.
//  Copyright © 2015 Tal Shrestha. All rights reserved.
//

#if os(macOS)
    
    import Cocoa
    import RxCocoa
#if !RX_NO_MODULE
    import RxSwift
#endif
    
    /// Delegate proxy for `NSTextView`.
    ///
    /// For more information take a look at `DelegateProxyType`.
    public class RxTextViewDelegateProxy
        : DelegateProxy<NSTextView,NSTextViewDelegate>
        , NSTextViewDelegate
    , DelegateProxyType {
        
        fileprivate let textSubject = PublishSubject<String?>()
        
        /// Typed parent object.
        public weak private(set) var textView: NSTextView?
        
        /// Initializes `RxTextViewDelegateProxy`
        ///
        /// - parameter parentObject: Parent object for delegate proxy.
        public required init(parentObject: AnyObject) {
            guard let textView = parentObject as? NSTextView else {
                fatalError("Can't get NSTextView")
                return
            }
            super.init(parentObject: parentObject)
        }
        
        // MARK: Delegate methods
        
        public override func controlTextDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                fatalError("Can't get NSTextView")
            }
            let nextValue = textView.string
            self.textSubject.on(.next(nextValue))
        }
        
        // MARK: Delegate proxy methods
        
        /// For more information take a look at `DelegateProxyType`.
        public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
            guard let control = object as? NSTextView else {
                fatalError("Can't get NSTextView")
            }
            return control.createRxDelegateProxy()
        }
        
        /// For more information take a look at `DelegateProxyType`.
        public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
            guard let textView = object as? NSTextView else {
                fatalError("Can't get NSTextView")
            }
            return textView.delegate
        }
        
        /// For more information take a look at `DelegateProxyType`.
        public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
            guard let textView = object as? NSTextView else {
                fatalError("Can't get NSTextView")
            }
            guard let textViewDelegate = delegate as? NSTextViewDelegate else {
                fatalError("Can't get NSTextView")
            }
            textView.delegate = textViewDelegate
        }
        
    }
    
    extension NSTextView {
        
        /// Factory method that enables subclasses to implement their own `delegate`.
        ///
        /// - returns: Instance of delegate proxy that wraps `delegate`.
        public func createRxDelegateProxy() -> RxTextViewDelegateProxy {
            return RxTextViewDelegateProxy(parentObject: self)
        }
    }
    
    extension Reactive where Base: NSTextView {
        
        /// Reactive wrapper for `delegate`.
        ///
        /// For more information take a look at `DelegateProxyType` protocol documentation.
        public var delegate: DelegateProxy {
            return RxTextViewDelegateProxy.proxyForObject(base)
        }
        
        /// Reactive wrapper for `text` property.
        public var text: ControlProperty<String?> {
            let delegate = RxTextViewDelegateProxy.proxyForObject(base)
            
            let source = Observable.deferred { [weak textView = self.base] in
                delegate.textSubject.startWith(textView?.string)
                }.takeUntil(deallocated)
            
            let observer = UIBindingObserver(UIElement: base) { (control, value: String?) in
                control.string = value ?? ""
            }
            
            return ControlProperty(values: source, valueSink: observer.asObserver())
        }
        
    }
    
#endif
