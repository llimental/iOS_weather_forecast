//
//  ViewModelDelegate.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/07/26.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func reloadData()
}
