//
//  GeocodingEndPoint.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/15.
//

import Foundation

final class GeocodingEndPoint: RequestAndResponse {
    typealias Response = Geocoding

    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init(cityName: String) {
        let api = OpenWeatherAPI.geocoding(cityName: cityName)

        scheme = OpenWeatherAPI.scheme
        host = OpenWeatherAPI.host
        path = api.path
        query = api.query
    }
}
