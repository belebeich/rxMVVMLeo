//
//  CustomNSTextField.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 21/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

class CustomNSTextField: NSTextField {

    var myColorCursor : NSCursor?
    
    var mouseIn : Bool = false
    
    var trackingArea : NSTrackingArea?
    
    override func awakeFromNib()
    {
//        myColorCursor = NSCursor.init(image: NSImage(named:NSImage.Name(rawValue: "heart"))!, hotSpot: NSMakePoint(0.0, 0.0))
        
        customizeCaretColor()
    }
    
    override func resetCursorRects() {
        if let colorCursor = myColorCursor {
            self.addCursorRect(self.bounds, cursor: colorCursor)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.mouseIn = true
        
        customizeCaretColor()
    }
    
   
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.mouseIn = false
    }
    
    override func mouseMoved(with event: NSEvent) {
        if self.mouseIn {
            myColorCursor?.set()
        }
        super.mouseMoved(with: event)
    }
    
    func setArea(areaToSet: NSTrackingArea?)
    {
        if let formerArea = trackingArea {
            self.removeTrackingArea(formerArea)
        }
        
        if let newArea = areaToSet {
            self.addTrackingArea(newArea)
        }
        trackingArea = areaToSet
    }
    
   
    
    func customizeCaretColor() {
        // change the insertion caret to another color
        guard let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView else {  return }
        
        
        
        fieldEditor.insertionPointColor = NSColor.white
        
        
        
        self.setNeedsDisplay()
    }
    
    override func becomeFirstResponder() -> Bool {
        let rect = self.bounds
        let trackingArea = NSTrackingArea.init(rect: rect, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        
        // keep track of where the mouse is within our text field
        self.setArea(areaToSet: trackingArea)
        
        if let ev = NSApp.currentEvent {
            if NSPointInRect(self.convert(ev.locationInWindow, from: nil), self.bounds) {
                self.mouseIn = true
                myColorCursor?.set()
            }
        }
        
        return true
    }
    
}



