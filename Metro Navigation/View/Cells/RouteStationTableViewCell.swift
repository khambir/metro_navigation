//
//  RouteStationTableViewCell.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/1/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

protocol RouteStationTableViewCellDelegate: class {
    func routeStationCellMapButtonDidTap(_ routeStationCell: RouteStationTableViewCell)
}

class RouteStationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    internal static var identifier: String {
        return String(describing: RouteStationTableViewCell.self)
    }
    internal weak var delegate: RouteStationTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var branchIndicatorImageView: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    
}

// MARK: - Actions
extension RouteStationTableViewCell {
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        delegate?.routeStationCellMapButtonDidTap(self)
    }
    
}
