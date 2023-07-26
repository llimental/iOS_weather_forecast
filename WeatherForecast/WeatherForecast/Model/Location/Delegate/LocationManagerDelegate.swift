//
//  LocationManagerDelegate.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/04/07.
//

import Foundation

protocol LocationManagerDelegate: AnyObject {
    var addressData: String { get set }

    func fetchData(with lat: Double, and lon: Double)
}
