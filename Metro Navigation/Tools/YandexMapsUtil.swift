//
//  YandexMapsUtil.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

struct YandexMapsUtil: LocationUtil {
    
    // MARK: - Properties
    var applicationName: String {
        return "YandexMaps".localized
    }
    
    var applicationPath: String {
        return "yandexmaps://"
    }
    
    // MARK: - Methods
    func openAndBuildRoute(to destination: CLLocationCoordinate2D) {
        let stringURL = "yandexmaps://build_route_on_map?lat_to=\(destination.latitude)&lon_to=\(destination.longitude)"
        guard let applicationURL =  URL(string: stringURL) else { return }
        UIApplication.shared.open(applicationURL, options: [:])
    }
    
}
