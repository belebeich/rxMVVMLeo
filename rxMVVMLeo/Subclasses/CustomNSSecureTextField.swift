//
//  CustomNSSecureTextField.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 03/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

class CustomNSSecureTextField: NSSecureTextField {
  
  var myColorCursor : NSCursor?
  var mouseIn : Bool = false
  var trackingArea : NSTrackingArea?
  
  override func awakeFromNib() {
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
  
  func setArea(areaToSet: NSTrackingArea?) {
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
    
    if let event = NSApp.currentEvent {
      if NSPointInRect(self.convert(event.locationInWindow, from: nil), self.bounds) {
        self.mouseIn = true
        myColorCursor?.set()
      }
    }
    return true
  }
}
