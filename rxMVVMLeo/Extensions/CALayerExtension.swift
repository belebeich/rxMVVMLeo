//
//  CALayerExtension.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 12/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

extension CALayer {
    func applySketchShadow(
        color: NSColor = .white,
        alpha: Float = 1.0,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4,
        spread: CGFloat = 3)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = NSBezierPath(rect: rect).cgPath
            
        }
    }
}
