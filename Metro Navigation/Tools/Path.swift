//
//  Path.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

class Path {
    
    // MARK: - Properties
    var total: Int!
    var destination: Vertex?
    var previous: Path!
    
    // MARK: - Init
    init(destination: Vertex? = nil, previous: Path? = nil, total: Int? = nil) {
        self.destination = destination
        self.previous = previous
        self.total = total
    }
    
    // MARK: - Methods
    internal func getHistory(from origin: Vertex) -> [Path] {
        var history = [Path]()
        history.append(self)
        
        var previousPath = previous
        while previousPath != nil {
            history.append(previousPath!)
            previousPath = previousPath!.previous
        }
        
        let path = Path()
        path.total = 0
        path.destination = origin
        path.previous = nil
        history.append(path)
        
        return history.reversed()
    }
    
}
