//
//  HomeViewModel.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import CoreLocation

class HomeViewModel: BaseViewModel {
    
    private var location: CLLocation?
    var favorites: [FetchCityResponse] = []
    
    private func appendCity(city: FetchCityResponse?) {
        guard let city = city else { return }
        
        for savedCity in favorites {
            if savedCity.name == city.name {
                return
            }
        }
        
        self.favorites.append(city)
        CoreDataStack.shared.insert(name: city.name)
    }
    
    func retrieveFavorites(completion: @escaping (Result<FetchCityResponse?, Error>) -> Void) {
        let favorites = CoreDataStack.shared.fetch()
        for favorite in favorites {
            if let name = favorite.name {
                fetchCity(name: name, completion: completion)
            }
        }
    }
    
    func fetchCity(name: String, completion: @escaping (Result<FetchCityResponse?, Error>) -> Void) {
        APIClient.shared.fetchCity(name: name) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                self.appendCity(city: response)
                completion(.success(response))
            }
        }
    }
    
    func fetchCity(loc: CLLocation, completion: @escaping (Result<FetchCityResponse?, Error>) -> Void) {
        guard self.location != loc else { return }
        self.location = loc
        
        APIClient.shared.fetchCity(loc: loc) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case.success(let response):
                self.appendCity(city: response)
                completion(.success(response))
            }
        }
    }
}

extension CLLocation {
    
    static func ==(lhs: CLLocation, rhs:CLLocation) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
