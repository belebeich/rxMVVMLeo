
import Foundation

#if os(macOS)
    
import Cocoa
import RxCocoa
#if !RX_NO_MODULE
import RxSwift
#endif
    
/// Delegate proxy for `NSTextView`.
///
/// For more information take a look at `DelegateProxyType`.
open class RxTextViewDelegateProxy
    : DelegateProxy<NSTextView,NSTextViewDelegate>
    , DelegateProxyType
    , NSTextViewDelegate {
    
    /// Typed parent object.
    public weak private(set) var textView: NSTextView?
    
    /// Initializes `RxTextViewDelegateProxy`
    ///
    /// - parameter textView: Parent object for delegate proxy.
    init(textView: NSTextView) {
        super.init(parentObject: textView, delegateProxy: RxTextViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxTextViewDelegateProxy(textView: $0)}
    }
    
    fileprivate let textSubject = PublishSubject<String?>()
    
    // MARK: Delegate methods
    
    open override func controlTextDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
            fatalError("Can't get NSTextView")
        }
        let nextValue = textView.string
        self.textSubject.on(.next(nextValue))
        _forwardToDelegate?.controlTextDidChange(notification)
    }
    
    // MARK: Delegate proxy methods
    
    /// For more information take a look at `DelegateProxyType`.
    open class func currentDelegate(for object: NSTextView) -> NSTextViewDelegate? {
        return object.delegate
    }
    
    /// For more information take a look at `DelegateProxyType`.
    open class func setCurrentDelegate(_ delegate: NSTextViewDelegate?, to object: NSTextView) {
        object.delegate = delegate
    }
    
}

    
extension Reactive where Base: NSTextView {
        
    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
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
