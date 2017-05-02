//
//  LocationUtil.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationUtil {
    /// Determines is application installed on the device or no.
    var isInstalled: Bool { get }
    var applicationPath: String { get }
    var applicationName: String { get }
    func openAndBuildRoute(to destination: CLLocationCoordinate2D)
}

extension LocationUtil {
    
    var isInstalled: Bool {
        guard let applicationURL = URL(string: applicationPath) else { return false }
        return UIApplication.shared.canOpenURL(applicationURL)
    }
    
}

struct LocationUtilManager {
    
    internal static var installedUtilities: [LocationUtil] {
        return [YandexMapsUtil(), YandexNavigatorUtil(), GoogleMapsUtil(), AppleMapsUtil()].filter { $0.isInstalled }
    }
    
}
