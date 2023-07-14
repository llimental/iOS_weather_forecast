//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/14.
//

import Foundation

enum OpenWeatherAPI {
    case weather(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    case geocoding(cityName: String)

    static var scheme: String {
        return "https"
    }

    static var host: String {
        return "api.openweathermap.org"
    }

    var path: String {
        switch self {
        case .weather: return "/data/2.5/weather"
        case .forecast: return "/data/2.5/forecast"
        case .geocoding: return "/geo/1.0/direct"
        }
    }

    var query: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let keyParameter = URLQueryItem(name: "appid", value: Bundle.main.apiKey)

        switch self {
        case .weather(let lat, let lon), .forecast(let lat, let lon):
            let latitudeParameter = URLQueryItem(name: "lat", value: "\(lat)")
            let longitudeParameter = URLQueryItem(name: "lon", value: "\(lon)")

            queryItems = [latitudeParameter, longitudeParameter, keyParameter]
        case .geocoding(let cityName):
            let nameParameter = URLQueryItem(name: "q", value: cityName)
            let limitParameter = URLQueryItem(name: "limit", value: "5")

            queryItems = [nameParameter, limitParameter, keyParameter]
        }

        return queryItems
    }
}
