//
//  CustomNSTextView.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 22/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

class CustomNSTextView: NSTextView {
  
  var caretWidth: CGFloat = 10
  var caretHeight: CGFloat = 2
  
  open override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
    var rect = rect
    rect.size.width = caretWidth
    rect.size.height = caretHeight
    rect.origin.y = 10
    super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
  }
  
  open override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout flag: Bool) {
    var rect = rect
    rect.size.width += caretWidth - 1
    rect.size.height += caretHeight - 1
    super.setNeedsDisplay(rect, avoidAdditionalLayout: flag)
  }
}



