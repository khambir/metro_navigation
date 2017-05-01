//
//  MetroStation.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/27/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

class MetroStation: Vertex {
    
    // MARK: - Properties
    internal var id: Int?
    internal let name: String
    internal let color: UIColor
    internal let location: CLLocation
    internal var edges: [Edge] = []
    
    // MARK: - Initializer
    init(id: Int, name: String, color: UIColor, location: CLLocation) {
        self.id = id
        self.name = name
        self.color = color
        self.location = location
    }
    
}
