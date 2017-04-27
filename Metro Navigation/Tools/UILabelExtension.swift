//
//  UILabelExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/27/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setText(_ text: String, withBoldPart boldTextPart: String) {
        attributedText = nil
        
        let result = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: font])
        result.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: font.pointSize)], range: NSString(string: text.lowercased()).range(of: boldTextPart.lowercased()))
        attributedText = result
    }
    
}
