//
//  NSViewExtention.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 04/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

extension NSView {
    enum GlowEffect:Float{
        case small = 0.4, normal = 2, big = 15
    }
    
    func doGlowAnimation(withColor color: NSColor, time: Double, withEffect effect: GlowEffect = .normal) {
        layer?.masksToBounds = false
        layer?.shadowColor = color.cgColor
        layer?.shadowRadius = 0
        layer?.shadowOpacity = 1
        layer?.shadowOffset = .zero
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = time+0.3
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = kCAFillModeRemoved
        glowAnimation.autoreverses = true
        glowAnimation.isRemovedOnCompletion = true
        layer?.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
