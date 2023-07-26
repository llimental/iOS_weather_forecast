//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController, ViewModelDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfiguration()
        setUpCollectionView()

        bindProperties()
        viewModel.delegate = self
        viewModel.setUpLocationManager()
    }

    // MARK: - Public Functions
    func reloadData() {
        DispatchQueue.main.async {
            if self.collectionView.refreshControl?.isRefreshing == true {
                self.collectionView.refreshControl?.endRefreshing()
            }
            self.collectionView.reloadData()
        }
    }

    // MARK: - Objc Functions
    @objc func refreshData() {
        viewModel.setUpLocationManager()
    }

    @objc func settingButtonTapped() {
        let alert = UIAlertController(title: "위치변경", message: "날씨를 확인하고 싶은 도시 이름을 입력해주세요", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "ex. 서울 or Seoul"
        }

        alert.addAction(UIAlertAction(title: "변경".localizedLowercase, style: .default, handler: { [unowned alert, weak self] _ in
            if let inputText = alert.textFields?.first?.text {
                self?.viewModel.getGeocodingData(from: inputText)
            }
        }))

        alert.addAction(UIAlertAction(title: "취소".localizedLowercase, style: .cancel))

        self.present(alert, animated: true)
    }
    
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

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getForecastListCount()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier, for: indexPath) as? WeatherCollectionViewHeader else {
            return UICollectionReusableView()
        }

        header.weatherImage.image = weatherIcon
        header.locationLabel.text = location
        header.tempMinAndMaxLabel.text = tempMinAndMax
        header.tempLabel.text = temperature
        header.settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)

        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.timeLabel.text = viewModel.getConvertedDate(of: indexPath)
        cell.temperatureLabel.text = viewModel.getTemperatureData(of: indexPath)
        cell.tempImage.image = viewModel.getTemperatureImage(of: indexPath)

        return cell
    }
}
