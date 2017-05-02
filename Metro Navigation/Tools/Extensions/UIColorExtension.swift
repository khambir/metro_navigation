//
//  UIColorExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/27/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(hex: String, alpha: CGFloat = 1) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hex.hasPrefix("#")) {
            hex.remove(at: hex.startIndex)
        }
        
        guard hex.characters.count == 6 else { return nil }
        
        let redPosition = hex.index(hex.startIndex, offsetBy: 2)
        let greenPosition = hex.index(hex.startIndex, offsetBy: 4)
        
        guard   let r = Double("0x" + hex.substring(to: redPosition)),
            let g = Double("0x" + hex.substring(with: redPosition..<greenPosition)),
            let b = Double("0x" + hex.substring(from: greenPosition))
            else { return nil }
        
        self.init(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: alpha)
    }
    
}
