//
//  Geocoding.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/15.
//

import Foundation

struct Geocoding: Decodable {
    let name: String
    let localNames: [String: String]
    let lat: Double
    let lon: Double
    let country: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
    }
}
