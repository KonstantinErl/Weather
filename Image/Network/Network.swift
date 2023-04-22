//
//  Network.swift
//  Image
//
//  Created by Константин on 14.04.2023.
//

import Foundation
import CoreLocation

class Network {
    
    func getWeather(latitude: Double, longitude: Double, completion: ((WeatherResponse?, Error?) -> Void)?) {
        let coord = "\(latitude),\(longitude)"
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/" + coord + "?unitGroup=metric&key=5PBP5UAAELVX2R4QXSHTBTWGX&contentType=json&lang=ru")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if data != nil && error == nil {
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data!)
                    
                    DispatchQueue.main.async {
                       completion?(weatherResponse, error)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } .resume()
    }
    
    func getCityName(latitude: Double, longitude: Double, completion: ((String?, Error?) -> Void)?) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            completion?(placemarks?.first?.locality, error)
        }
    }
}
