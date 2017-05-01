//
//  MetroNavigation.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

final class MetroNavigation {
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Properties
    private var _metroStations: [MetroStation] = []
    internal static let shared = MetroNavigation()
    internal var metroStations: [MetroStation] {
        if !_metroStations.isEmpty {
            return _metroStations
        }
        
        guard let path = Bundle.main.path(forResource: "kyivMetroStations", ofType: "plist") else { return [] }
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
            _metroStations.append(newStation)
        }
        
        return _metroStations
    }
}
