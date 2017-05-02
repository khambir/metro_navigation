//
//  StringExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

extension String {

    private var fileNameWithStrings: String {
        return "Localizable"
    }
    
    internal var localized: String {
        return NSLocalizedString(self, tableName: fileNameWithStrings, bundle: Bundle.main, value: "", comment: "")
    }
    
    
}
