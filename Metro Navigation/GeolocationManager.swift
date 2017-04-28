//
//  GeolocationManager.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/26/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation

protocol GeolocationManagerDelegate: class {
    func geolocationManager(_ geolocationManager: GeolocationManager, receivedNewLocation location: CLLocation)
}

class GeolocationManager: CLLocationManager {
    
    // MARK: - Properties
    fileprivate var updaitingLocation = false
    fileprivate var deviceLocation: CLLocation?
    fileprivate var locationManager = CLLocationManager()
    internal var currentLocation: CLLocationCoordinate2D? {
        return deviceLocation?.coordinate
    }
    internal weak var geoManagerDelegate: GeolocationManagerDelegate?
    
    // MARK: - Init
    override init() {
        super.init()
        startLocationManager()
    }
    
    // MARK: - Methods
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            updaitingLocation = true
        }
    }
    
    fileprivate func stopLocationManager() {
        if updaitingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updaitingLocation = false
        }
    }
    
}

// MARK: - CLLocationManagerDelegate functions
extension GeolocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, newLocation.horizontalAccuracy >= 0 else { return }
        
        // If the time at which the location was determined is too long ago then this is a cached result.
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }

        if deviceLocation == nil || deviceLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
            deviceLocation = newLocation
            geoManagerDelegate?.geolocationManager(self, receivedNewLocation: deviceLocation!)
            // If the new location’s accuracy is equal to or better than the desired accuracy, stop asking the location manager for updates.
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
            }
        }
    }
    
}
