//
//  MyWeatherAppTests.swift
//  MyWeatherAppTests
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import CoreLocation
import XCTest
@testable import MyWeatherApp

class MyWeatherAppTests: XCTestCase {
    
    let location = CLLocation(latitude: 35, longitude: 135)
    
    var viewModel = HomeViewModel()
    var cityViewModel: CityViewModel?
    
    override func setUp() {
        viewModel.fetchCity(loc: location) { (result) in
            switch result {
            case .failure: XCTFail()
            case .success(let city):
                if let city = city {
                    self.cityViewModel = CityViewModel(city: city)
                    self.viewModel.favorites.append(city)
                }
            }
        }
    }
    
    func testDidFetchCity() {
        XCTAssertEqual(self.viewModel.favorites.count, 2, "passed")
    }
    
    func testDidFetchCityWithName() {
        viewModel.fetchCity(name: "Nairobi") { (result) in
            switch result {
            case .failure: XCTFail()
            case .success:
                XCTAssertEqual(self.viewModel.favorites.count, 3, "passed")
            }
        }
    }
}
