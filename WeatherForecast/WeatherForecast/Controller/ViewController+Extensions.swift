//
//  ViewController+Extensions.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit
import CoreLocation

extension ViewController: LocationManagerDelegate {
    func fetchData(with lat: Double, and lon: Double) {
        Task {
            weather = try await networkManager.callWeatherAPI(with: WeatherEndPoint(lat: lat, lon: lon))
            forecast = try await networkManager.callForecastAPI(with: ForecastEndPoint(lat: lat, lon: lon))

            guard let weatherIconString = weather?.weather.first?.icon else { return }
            weatherIcon = try await networkManager.callWeatherIconAPI(weatherStatus: weatherIconString)

            guard let forecastList = forecast?.list else { return }
            forecastIcons = try await networkManager.callForecastIconAPI(forecastList: forecastList)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast?.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier, for: indexPath) as? WeatherCollectionViewHeader else {
            return UICollectionReusableView()
        }

        header.weatherImage.image = weatherIcon
        header.locationLabel.text = locationManager.address == "" ? "-" : locationManager.address

        header.tempMinAndMaxLabel.text = weather?.main.tempMin != nil && weather?.main.tempMax != nil ? "최저 \(String(format: "%.1f", weather?.main.tempMin ?? 0))° 최대 \(String(format: "%.1f", weather?.main.tempMax ?? 0))°" : "-"

        header.tempLabel.text = weather?.main.temp == nil ? "-" : "\(String(format: "%.1f", weather?.main.temp ?? 0))°"

        header.settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)

        return header
    }

    @objc func settingButtonTapped() {
        let alert = UIAlertController(title: "위치변경", message: "날씨를 확인하고 싶은 도시 이름을 입력해주세요", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "ex. 서울 or Seoul"
        }

        alert.addAction(UIAlertAction(title: "변경".localizedLowercase, style: .default, handler: { [unowned alert, weak self] _ in
            if let inputText = alert.textFields?.first?.text {
                self?.getGeocodingData(from: inputText)
            }
        }))

        alert.addAction(UIAlertAction(title: "취소".localizedLowercase, style: .cancel))

        self.present(alert, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let forecastData = forecast?.list[indexPath.row] {
            let conversionTimeDataToDate = Date(timeIntervalSinceReferenceDate: TimeInterval(forecastData.timeOfData))

            cell.timeLabel.text = dateFormatter.string(from: conversionTimeDataToDate)

            cell.temperatureLabel.text = String(format: "%.1f", forecastData.main.temp) + "°"

            if let forecastIconData = forecastIcons {
                if let forecastStatus = forecastData.weather.first?.icon {
                    cell.tempImage.image = forecastIconData[forecastStatus]
                }
            }
        }

        return cell
    }
}
