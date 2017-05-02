//
//  AppleMapsUtil.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

struct AppleMapsUtil: LocationUtil {
    
    // MARK: - Properties
    var applicationName: String {
        return "AppleMaps".localized
    }
    
    var applicationPath: String {
        return ""
    }
    
    var isInstalled: Bool {
        return true
    }
    
    // MARK: - Methods
    func openAndBuildRoute(to destination: CLLocationCoordinate2D) {
        let stringURL = "http://maps.apple.com/?daddr=\(destination.latitude),\(destination.longitude)"
        guard let applicationURL =  URL(string: stringURL) else { return }
        UIApplication.shared.open(applicationURL, options: [:])
    }
    
}
