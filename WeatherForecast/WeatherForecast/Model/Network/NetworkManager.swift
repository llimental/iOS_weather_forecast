//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/21.
//

import UIKit
import CoreLocation

final class NetworkManager {

    private let session: URLSession

    init() {
        session = URLSession(configuration: .default)
    }
    
    // MARK: - Public
    func callWeatherAPI<D: Decodable, R: RequestAndResponse>(with endPoint: R) async throws -> D where R.Response == D {
        let weatherURLRequest = try endPoint.makeURLRequest()

        let (data, _) = try await session.data(for: weatherURLRequest)
        let weather: D = try JSONDecoder().decode(D.self, from: data)

        print("[NetworkManager](fetched)weather")
        return weather
    }

    func callForecastAPI<D: Decodable, R: RequestAndResponse>(with endPoint: R) async throws -> D where R.Response == D {
        let forecastURLRequest = try endPoint.makeURLRequest()
        
        let (data, _) = try await session.data(for: forecastURLRequest)
        let forecast = try JSONDecoder().decode(D.self, from: data)

        print("[NetworkManager](fetched)forecast")
        return forecast
    }

    func callWeatherIconAPI(weatherStatus: String) async throws -> UIImage? {
        let weatherIconURL = try getURL(string: "https://openweathermap.org/img/wn/\(weatherStatus)@2x.png")
        var weatherIconURLRequest = URLRequest(url: weatherIconURL)

        weatherIconURLRequest.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: weatherIconURLRequest)
        let weatherIconImage = UIImage(data: data)

        print("[NetworkManager](fetched)WeatherIcon")
        return weatherIconImage
    }

    func callForecastIconAPI(forecastList: [Forecast.List]) async throws -> [String: UIImage]? {
        var imageSet: [String: UIImage] = [:]

        for forecastCase in forecastList {
            if let forecastStatus = forecastCase.weather.first?.icon {
                let forecastIconURL = try getURL(string: "https://openweathermap.org/img/wn/\(forecastStatus)@2x.png")
                var forecastIconURLRequest = URLRequest(url: forecastIconURL)

                forecastIconURLRequest.httpMethod = "GET"

                let (data, _) = try await URLSession.shared.data(for: forecastIconURLRequest)

                imageSet[forecastStatus] = UIImage(data: data)
            }
        }

        print("[NetworkManager](fetched)ForecastIcon")
        return imageSet
    }

    // MARK: - Private
    private func getURL(string: String) throws -> URL {
        guard let weatherURL = URL(string: string) else {
            throw NetworkError.invalidURL
        }
        return weatherURL
    }
}
