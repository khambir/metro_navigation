//
//  MetroStation.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/27/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

struct MetroStation {
    
    // MARK: - Properties
    internal let id: Int
    internal let name: String
    internal let color: UIColor
    internal let location: CLLocation
    
    // MARK: - Methods
    internal static func loadAll() -> [MetroStation] {
        
        var result: [MetroStation] = []
        
        guard let path = Bundle.main.path(forResource: "kyivMetroStations", ofType: "plist") else { return [] }
        //If your plist contain root as Array
        guard let stations = NSArray(contentsOfFile: path) as? [[String: Any]] else { return [] }
        
        for station in stations {
            guard   let id = station["id"] as? Int,
                let name = station["name"] as? String,
                let color = UIColor(hex: station["lineColor"] as? String ?? ""),
                let location = station["location"] as? [String: Any],
                let latitude = location["latitude"] as? Double,
                let longitude = location["longitude"] as? Double else {
                    continue
            }
            let newStation = MetroStation(id: id, name: name, color: color, location: CLLocation(latitude: latitude, longitude: longitude))
            result.append(newStation)
        }
        
        return result
    }
    
}
