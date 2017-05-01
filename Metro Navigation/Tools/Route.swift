//
//  Route.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

struct Route: Edge {
    
    // MARK: - Properties
    var neighbor: Vertex
    var weight: Int
    
    // MARK: - Methods
    internal static func loadAll() {
        guard let path = Bundle.main.path(forResource: "kyivMetroRoutes", ofType: "plist") else { return }
        guard let routes = NSArray(contentsOfFile: path) as? [[String: Any]] else { return }
        let stations = MetroNavigation.shared.metroStations
        
        for route in routes {
            guard
                    let weight = route["weight"] as? Int,
                    let fromMetro = (stations.filter { $0.id == route["fromID"] as? Int }).first,
                    let toMetro = (stations.filter{ $0.id == route["toID"] as? Int }).first
                else { continue }
            
            fromMetro.edges.append(Route(neighbor: toMetro, weight: weight))
            toMetro.edges.append(Route(neighbor: fromMetro, weight: weight))
        }
    }
    
}
