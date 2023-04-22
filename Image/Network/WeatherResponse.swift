import Foundation

struct WeatherResponse: Decodable {
    let latitude, longitude: Double
    let address, timezone: String
    let days: [CurrentConditions]
    let currentConditions: CurrentConditions
}

struct CurrentConditions: Decodable {
    let datetime: String
    let temp: Double
    let conditions: String
    let icon: String
    let hours: [CurrentConditions]?
}

