//
//  RxTableViewDataSourceProxy.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 26/08/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import Cocoa
import RxCocoa

let tableViewDataSourceNotSet = TableViewDataSourceNotSet()

class TableViewDataSourceNotSet
    : NSObject
, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }
}

/// For more information take a look at `DelegateProxyType`.
public class RxTableViewDataSourceProxy
    : DelegateProxy<AnyObject, Any>
    , NSTableViewDataSource
, DelegateProxyType {
    public static func registerKnownImplementations() {
        <#code#>
    }
    
    public static func currentDelegate(for object: AnyObject) -> Any? {
        <#code#>
    }
    
    public static func setCurrentDelegate(_ delegate: Any?, to object: AnyObject) {
        <#code#>
    }
    
    public func setForwardToDelegate(_ forwardToDelegate: Any?, retainDelegate: Bool) {
        <#code#>
    }
    
    
    /// Typed parent object.
    public weak private(set) var tableView: NSTableView?
    
    fileprivate weak var _requiredMethodsDataSource: NSTableViewDataSource? = tableViewDataSourceNotSet
    
    public required init(parentObject: AnyObject) {
        self.tableView = (parentObject as! NSTableView)
        super.init(parentObject: parentObject, delegateProxy: de)
    }
    
    // MARK: delegate
    
    /// Required delegate method implementation.
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return (_requiredMethodsDataSource ?? tableViewDataSourceNotSet).numberOfRows!(in: tableView)
    }
    
    /// Required delegate method implementation.
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return (_requiredMethodsDataSource ?? tableViewDataSourceNotSet).tableView!(tableView, objectValueFor: tableColumn, row: row)
    }
    
    // MARK: delegate proxy
    
    /// For more information take a look at `DelegateProxyType`.
    public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
        let tableView = (object as! NSTableView)
        return castOrFatalError(tableView.createRxDataSourceProxy())
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let tableView: NSTableView = castOrFatalError(object)
        tableView.dataSource = castOptionalOrFatalError(delegate)
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let tableView: NSTableView = castOrFatalError(object)
        return tableView.dataSource
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public override func setForwardToDelegate(_ forwardToDelegate: AnyObject?, retainDelegate: Bool) {
        let requiredMethodsDataSource: NSTableViewDataSource? = castOptionalOrFatalError(forwardToDelegate)
        _requiredMethodsDataSource = requiredMethodsDataSource ?? tableViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}

