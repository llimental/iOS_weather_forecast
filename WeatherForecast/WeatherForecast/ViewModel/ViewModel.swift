//
//  ViewModel.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/24.
//

import Foundation
import UIKit.UIImage

public class ViewModel {
    // MARK: - Public Properties
    let weatherIcon: Box<UIImage?> = Box(nil)
    let forecastIcons: Box<[String: UIImage]?> = Box(nil)
    let address = Box("Loading...")
    let tempMinAndMax = Box("-°, -°")
    let temperature = Box("-°")

    // MARK: - Private Properties
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        return dateFormatter
    }

    private var weather: Weather?
    private var forecast: Forecast?

    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
}
