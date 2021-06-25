//
//  ForecastCell.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    func configureForecastCell (temp: Temp) {
        minLabel.text = "\(temp.min.description)°"
        currentLabel.text = "\(temp.day.description)°"
        maxLabel.text = "\(temp.max.description)°"
    }
}
