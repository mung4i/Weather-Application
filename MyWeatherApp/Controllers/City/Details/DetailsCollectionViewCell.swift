//
//  DetailsCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets

    @IBOutlet weak var detailsBorder: UIView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(details: List, row: Int) {
        detailTitle.text = Date().getNextDate(current: row)
        detailDescription.text = "\(details.temp.day.description)°"
        setWeatherImage(weather: details.weather.first)
    }
    
    func setWeatherImage(weather: Weather?) {
        guard let weather = weather else { return }
        switch weather.type {
        case .cloudy:
            imageView.image = UIImage(named: "partlysunny")
        case .rainy:
            imageView.image = UIImage(named: "rain")
        case .sunny:
            imageView.image = UIImage(named: "clear")
        }
    }
}
