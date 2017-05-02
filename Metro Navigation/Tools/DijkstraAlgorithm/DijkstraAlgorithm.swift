//
//  DijkstraAlgorithm.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

class DijkstraAlgorithm {
    
    internal static func getShortestPath(from source: Vertex, to destination: Vertex) -> Path? {
        var frontier = source.frontier
        var finalPaths: [Path] = []
        
        var visited: [Int] = []
        var bestPath = Path()
        while frontier.count != 0 {
            bestPath = Path()
            var bestPathID = 0
            for pathID in 0..<frontier.count {
                if (bestPath.total == nil) || (frontier[pathID].total < bestPath.total) {
                    bestPath = frontier[pathID]
                    bestPathID = pathID
                }
            }
            
            for edge in bestPath.destination?.edges ?? [] {
                guard let id = edge.neighbor.id, !visited.contains(id) else { continue }
                visited.append(id)
                let newPath = Path(destination: edge.neighbor, previous: bestPath, total: bestPath.total + edge.weight)
                frontier.append(newPath)
            }
            finalPaths.append(bestPath)
            frontier.remove(at: bestPathID)
        }
        return finalPaths.filter( {$0.destination?.id == destination.id} ).first
    }
    
}
