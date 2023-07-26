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

        bindProperties()
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



        
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        locationManager.delegate = self
        setUpLocationManager()
    }
    
    // MARK: - Private function
    private func setUpLocationManager() {
        locationManager.startUpdatingLocation()
    // MARK: - Private Functions
    private func bindProperties() {
        viewModel.weatherIcon.bind { [weak self] icon in
            self?.weatherIcon = icon
        }

        viewModel.address.bind { [weak self] address in
            self?.location = address
        }

        viewModel.tempMinAndMax.bind { [weak self] tempMinAndMax in
            self?.tempMinAndMax = tempMinAndMax
        }

        viewModel.temperature.bind { [weak self] temperature in
            self?.temperature = temperature
        }
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

    // MARK: - Private Properties
    private let viewModel = ViewModel()

    private var collectionView = WeatherCollectionView(frame: .zero)
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_wallpaper")

        return imageView
    }()

    private var weatherIcon: UIImage?
    private var location: String?
    private var tempMinAndMax: String?
    private var temperature: String?
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

