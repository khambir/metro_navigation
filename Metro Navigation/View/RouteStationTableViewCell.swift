//
//  RouteStationTableViewCell.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

class RouteStationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    internal static var identifier: String {
        return String(describing: RouteStationTableViewCell.self)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var branchIndicatorImageView: UIImageView!
    
}
