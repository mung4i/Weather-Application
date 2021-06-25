//
//  CityViewModel.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import CoreLocation

import RxCocoa
import RxSwift

class BaseViewModel {
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    
}

class CityViewModel: BaseViewModel {
    // MARK:- Properties
    let city: FetchCityResponse
    var list: [List]? { forecast?.list }
    private var forecast: ForecastResponse?
    
    // MARK:- Initializer
    init(city: FetchCityResponse) {
        self.city = city
    }
     
    // MARK:- Methods
    func fetchForecast() {
        APIClient.shared.fetchForecast(city: self.city) { (result) in
            switch result {
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
                
            case let .success(forecast):
                self.forecast = forecast
            }
        }
    }
}
