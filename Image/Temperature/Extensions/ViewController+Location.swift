//
//  ViewController+Location.swift
//  Image
//
//  Created by Константин on 14.04.2023.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("my location = \(location)")
            myLocation = location
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: -
    
    func locationDidFind(_ location: CLLocation) {
        networkManager.getCityName(latitude: location.coordinate.latitude,
                                   longitude: location.coordinate.longitude) { [weak self] cityName, error in
            self?.currentCityName = cityName
            self?.updateCity()
            
            self?.getWeatherIn(location: location)
        }
    }
}
