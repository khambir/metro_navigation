//
//  SearchStantionTableViewCell.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/28/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

class SearchStantionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    internal static var identifier: String {
        return String(describing: SearchStantionTableViewCell.self)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var branchIndicatorView: UIView!
    
}
