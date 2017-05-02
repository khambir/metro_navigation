//
//  GoogleMapsUtil.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

struct GoogleMapsUtil: LocationUtil {
    
    // MARK: - Properties
    var applicationName: String {
        return "GoogleMaps".localized
    }
    
    var applicationPath: String {
        return "comgooglemaps-x-callback://"
    }
    
    // MARK: - Methods
    func openAndBuildRoute(to destination: CLLocationCoordinate2D) {
        let stringURL = "comgooglemaps-x-callback://?daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving&x-success=checker://?resume=true&&x-source=MetroNavi"
        guard let applicationURL =  URL(string: stringURL) else { return }
        UIApplication.shared.open(applicationURL, options: [:])
    }
    
}
