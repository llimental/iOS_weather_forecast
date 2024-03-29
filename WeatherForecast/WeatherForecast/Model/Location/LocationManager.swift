//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - CLLocationManager Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print(LocationError.emptyLocation.localizedDescription)
            return
        }
        print("[LocationManager](updated)location")
        delegate?.fetchData(with: location.coordinate.latitude, and: location.coordinate.longitude)
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    // MARK: - Public Functions
    func startUpdatingLocation() {
        setUp()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Private Functions
    private func setUp() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            var reversedAddress = ""

            guard let placemark = placemarks?.first else { return }

            if let administrativeArea = placemark.administrativeArea { reversedAddress += administrativeArea }

            if let locality = placemark.locality { reversedAddress += " \(locality)" }

            self.delegate?.addressData = reversedAddress
        }
    }

    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()

    weak var delegate: LocationManagerDelegate?
}
