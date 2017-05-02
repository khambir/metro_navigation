//
//  TimeIntervalExtension.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

extension TimeInterval {

    var dateComponents: (hours: Int, minutes: Int) {
        let interval = Int(self)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return (hours, minutes)
    }
    
}
