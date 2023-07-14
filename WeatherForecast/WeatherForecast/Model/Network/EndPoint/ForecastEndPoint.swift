//
//  ForecastEndPoint.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/15.
//

import Foundation

final class ForecastEndPoint: RequestAndResponse {
    typealias Response = Forecast

    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init(lat: Double, lon: Double) {
        let api = OpenWeatherAPI.forecast(lat: lat, lon: lon)

        scheme = OpenWeatherAPI.scheme
        host = OpenWeatherAPI.host
        path = api.path
        query = api.query
    }
}
