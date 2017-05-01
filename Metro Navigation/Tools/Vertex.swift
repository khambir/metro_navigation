//
//  Vertex.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

protocol Vertex {
    var id: Int? { get set }
    var edges: [Edge] { get set }
}

extension Vertex {
    
    var frontier: [Path] {
        var result: [Path] = []
        for edge in edges {
            let newPath = Path(destination: edge.neighbor, previous: nil, total: edge.weight)
            result.append(newPath)
        }
        return result
    }
    
}
