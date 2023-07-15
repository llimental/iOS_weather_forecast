//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Private property
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private(set) var address = ""

    weak var delegate: LocationManagerDelegate?

    // MARK: - Public
    func startUpdatingLocation() {
        setUp()
    }

    func setAddress(with currentAddress: String) {
        address = currentAddress
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Lifecycle
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
    
    // MARK: - Private
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

            self.setAddress(with: reversedAddress)
        }
    }
}
