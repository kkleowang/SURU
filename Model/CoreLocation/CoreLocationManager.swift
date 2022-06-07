//
//  CoreLocationManager.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/6.
//

import Foundation
import CoreLocation

class CoreLocationManager: NSObject {
    static let shared = CoreLocationManager()
    
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    private override init() {}
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        currentLocation = location
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        currentLocation = CLLocation(latitude: 0, longitude: 0)
    }
}
