//
//  CustomNSTableView.swift
//  rxMVVMLeoToday
//
//  Created by Ivan  on 14/08/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

public class CustomNSTableView: NSTableView {

    override public func drawGrid(inClipRect clipRect: NSRect) {
        
        let lastRowRect = self.rect(ofRow: (self.numberOfRows - 1 ))
        let myClipRect = NSMakeRect(0, 0, lastRowRect.size.width, lastRowRect.size.height)
        
        let finalRect = NSIntersectionRect(clipRect, myClipRect)
        
        super.drawGrid(inClipRect: finalRect)
    }
    
    
    
}
