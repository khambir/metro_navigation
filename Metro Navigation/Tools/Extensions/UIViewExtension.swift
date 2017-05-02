//
//  UIViewExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
    
    func addParallaxEffect() {
        let value = 20
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -value
        horizontal.maximumRelativeValue = value
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -value
        vertical.maximumRelativeValue = value
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
    
}
