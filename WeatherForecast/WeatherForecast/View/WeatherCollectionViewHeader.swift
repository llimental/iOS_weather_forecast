//
//  WeatherCollectionViewHeader.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/04/07.
//

import UIKit

class WeatherCollectionViewHeader: UICollectionReusableView {

    // MARK: - Static property
    static let headerIdentifier = "WeatherCollectionViewHeader"

    // MARK: - Public property
    var weatherImage = UIImageView()
    var informationStack = UIStackView()
    var locationLabel = UILabel()
    var tempMinAndMaxLabel = UILabel()
    var tempLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {

        super.init(frame: frame)

        addSubview(weatherImage)
        addSubview(informationStack)

        informationStack.addArrangedSubview(locationLabel)
        informationStack.addArrangedSubview(tempMinAndMaxLabel)
        informationStack.addArrangedSubview(tempLabel)

        configureConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureUI() {
        weatherImage.contentMode = .scaleAspectFit

        informationStack.axis = .vertical
        informationStack.spacing = 5
        informationStack.setCustomSpacing(15, after: tempMinAndMaxLabel)
        informationStack.alignment = .leading
        informationStack.distribution = .fillProportionally

        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 15)

        tempMinAndMaxLabel.textColor = .white
        tempMinAndMaxLabel.font = UIFont.systemFont(ofSize: 15)

        tempLabel.textColor = .white
        tempLabel.font = UIFont.systemFont(ofSize: 30)
    }

    private func configureConstraints() {
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        informationStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: self.topAnchor),
            weatherImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: self.frame.width * 0.25),

            informationStack.topAnchor.constraint(equalTo: self.topAnchor),
            informationStack.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor),
            informationStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
