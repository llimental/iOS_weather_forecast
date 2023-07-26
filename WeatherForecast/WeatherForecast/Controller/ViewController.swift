//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Public property
    let networkManager = NetworkManager()
    let locationManager = LocationManager()
    
    let dateFormatter = DateFormatter()

    var weather: Weather?
    var forecast: Forecast?
    var weatherIcon: UIImage?
    var forecastIcons: [String: UIImage]? {
        didSet {
            if collectionView.refreshControl?.isRefreshing == true {
                collectionView.refreshControl?.endRefreshing()
            }
            collectionView.reloadData()
        }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfiguration()
        setUpCollectionView()
    }

    // MARK: - Public function
    func getGeocodingData(from inputText: String) {
        Task {
            if let geocoding = try await networkManager.callGeocodingAPI(with: GeocodingEndPoint(cityName: inputText)).first {
                locationManager.setAddress(with: "\(geocoding.name)(\(geocoding.country))")
                fetchData(with: geocoding.lat, and: geocoding.lon)
            } else {
                print(NetworkError.invalidCityName.errorDescription)
            }
        }
    }

    // MARK: - Private property
    private var collectionView = WeatherCollectionView(frame: .zero)
    
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_wallpaper")

        return imageView
    }()

        
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        locationManager.delegate = self
        setUpLocationManager()
    }
    
    // MARK: - Private function
    private func setUpLocationManager() {
        locationManager.startUpdatingLocation()
    }

    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(WeatherCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier)
        collectionView.register(WeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: WeatherCollectionViewCell.cellIdentifier)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        locationManager.startUpdatingLocation()
    }

    private func viewConfiguration() {
        view.addSubview(backgroundView)
        view.addSubview(collectionView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    }

}

