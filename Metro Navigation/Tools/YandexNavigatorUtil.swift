//
//  YandexNavigatorUtil.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

struct YandexNavigatorUtil: LocationUtil {
    
    // MARK: - Properties
    var applicationName: String {
        return "YandexNavigator".localized
    }
    
    var applicationPath: String {
        return "yandexnavi://"
    }
    
    // MARK: - Methods
    func openAndBuildRoute(to destination: CLLocationCoordinate2D) {
        let stringURL = "yandexnavi://build_route_on_map?lat_to=\(destination.latitude)&lon_to=\(destination.longitude)"
        guard let applicationURL =  URL(string: stringURL) else { return }
        UIApplication.shared.open(applicationURL, options: [:])
    }
    
}
