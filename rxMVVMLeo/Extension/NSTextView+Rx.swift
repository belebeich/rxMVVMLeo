
import Foundation

#if os(macOS)
    
    import Cocoa
    import RxCocoa
#if !RX_NO_MODULE
    import RxSwift
#endif
    
    /// Delegate proxy for `NSTextView`.
    public class RxTextViewDelegateProxy : DelegateProxy<NSTextView,NSTextViewDelegate>, NSTextViewDelegate, DelegateProxyType {
        
        public static func registerKnownImplementations() {
            self.register { RxTextViewDelegateProxy(textView: $0)}
        }
        
        public static func currentDelegate(for object: NSTextView) -> NSTextViewDelegate? {
            
            return object.delegate
        }
        
        public static func setCurrentDelegate(_ delegate: NSTextViewDelegate?, to object: NSTextView) {
            
            if delegate == nil {
                object.delegate = nil
            } else {
                
                object.delegate = delegate
            }
        }
        
        
        fileprivate let textSubject = PublishSubject<String?>()
        
        /// Typed parent object.
        public weak private(set) var textView: NSTextView?
        
        /// Initializes `RxTextViewDelegateProxy`
        init(textView: NSTextView) {
            super.init(parentObject: textView, delegateProxy: RxTextViewDelegateProxy.self)
        }
        
        // MARK: Delegate methods
        public override func controlTextDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                fatalError("Can't get NSTextView")
            }
            let nextValue = textView.string
            self.textSubject.on(.next(nextValue))
        }
    }
    
//    extension NSTextView {
//        
//        /// Factory method that enables subclasses to implement their own `delegate`.
//        ///
//        /// - returns: Instance of delegate proxy that wraps `delegate`.
//        public func createRxDelegateProxy() -> RxTextViewDelegateProxy {
//            return RxTextViewDelegateProxy.init(textView: self)
//        }
//    }
    
    extension Reactive where Base: NSTextView {
        
        /// Reactive wrapper for `delegate`.
        public var delegate: DelegateProxy<NSTextView, NSTextViewDelegate> {
            return RxTextViewDelegateProxy.proxy(for: base)
        }
        
        /// Reactive wrapper for `text` property.
        public var text: ControlProperty<String?> {
            let delegate = RxTextViewDelegateProxy.proxy(for: base)
            
            let source = Observable.deferred { [weak textView = self.base] in
                delegate.textSubject.startWith(textView?.string)
                }.takeUntil(deallocated)
            
            
            let observer = Binder(base) { (control, value: String?) in
                control.string = value ?? ""
            }
            
            return ControlProperty(values: source, valueSink: observer.asObserver())
        }
        
    }
    
#endif
