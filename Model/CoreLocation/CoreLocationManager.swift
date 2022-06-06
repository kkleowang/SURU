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

    private override init() {
        
    }
    func getLocation() {
        //TODO:Set up the location manager here.
               locationManager.delegate = self  //宣告自己 (current VC)為 locationManager 的代理
               locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //定位所在地的精確程度(一般來說，精準程度越高，定位時間越長，所耗費的電力也因此更多)
               //to ask the user for location
               locationManager.requestWhenInUseAuthorization()
        //for not destroying the user's battery
               locationManager.startUpdatingLocation()
        //this method will start navigating the location. And once this is done, it will send a msg to this ViewController
    }
    
    
}

extension CoreLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        currentLocation = location
        if location.horizontalAccuracy > 0 {
               locationManager.stopUpdatingLocation()
                print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
                }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        currentLocation = CLLocation(latitude: 0, longitude: 0)
     }
    
    
}
