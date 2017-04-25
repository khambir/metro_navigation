//
//  SegueHandler.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

protocol SegueHandler {
    associatedtype ViewControllerSegue: RawRepresentable
}

extension SegueHandler where Self: UIViewController, ViewControllerSegue.RawValue == String {
    
    func getIdentifierCase(for segue: UIStoryboardSegue) -> ViewControllerSegue {
        guard let segueID = segue.identifier, let segueCase = ViewControllerSegue(rawValue: segueID) else {
            fatalError("Could not map segue identifier -- \(String(describing: segue.identifier)) -- to segue case")
        }
        return segueCase
    }
    
}
