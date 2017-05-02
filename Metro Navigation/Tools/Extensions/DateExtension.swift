//
//  DateExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

extension Date {

    internal var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
}
