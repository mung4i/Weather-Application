//
//  FavoriteCityCell.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

class FavoriteCityCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    
    func configureCell(favorite: FetchCityResponse) {
        locationLabel.text = favorite.name
        temperatureLabel.text = "\(Int(favorite.main.temp)) ℃"
        weatherConditionLabel.text = favorite.weather.first?.type.rawValue
        
        setCellContentBackgroundColor(weather: favorite.weather.first)
        setWeatherImage(weather: favorite.weather.first)
    }
    
    private func setCellContentBackgroundColor(weather: Weather?) {
        guard let type = weather?.type else { return }
        switch type {
        case .cloudy:
            contentView.backgroundColor = UIColor.cloudyColor
        case .rainy:
            contentView.backgroundColor = UIColor.rainyColor
        case .sunny:
            contentView.backgroundColor = UIColor.sunnyColor
        }
    }
    
    func setWeatherImage(weather: Weather?) {
        guard let weather = weather else { return }
        switch weather.type {
        case .cloudy:
            weatherTypeImage.image = UIImage(named: "partlysunny")
        case .rainy:
            weatherTypeImage.image = UIImage(named: "rain")
        case .sunny:
            weatherTypeImage.image = UIImage(named: "clear")
        }
    }

}
