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

    weak var delegate: ViewModelDelegate?

    func getConvertedDate(of indexPath: IndexPath) -> String {
        if let forecastData = forecast?.list[indexPath.row] {
            let conversionTimeDataToDate = Date(timeIntervalSinceReferenceDate: TimeInterval(forecastData.timeOfData))

            return dateFormatter.string(from: conversionTimeDataToDate)
        } else {
            return "-"
        }
    }

    func getTemperatureData(of indexPath: IndexPath) -> String {
        return String(format: "%.1f", forecast?.list[indexPath.row].main.temp ?? "-") + "°"
    }

    func getTemperatureImage(of indexPath: IndexPath) -> UIImage? {
        guard let forecastData = forecast?.list[indexPath.row] else { return UIImage() }

        guard let forecastIconData = forecastIcons.value, let forecastStatus = forecastData.weather.first?.icon else { return UIImage() }

        return forecastIconData[forecastStatus]
    }

    func getForecastListCount() -> Int {
        return forecast?.list.count ?? 10
    }

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
