//
//  Edge.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import Foundation

protocol Edge {
    var neighbor: Vertex { get set }
    var weight: Int { get set }
}
