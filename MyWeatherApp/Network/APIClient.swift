//
//  APIClient.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import CoreLocation
import Foundation

struct APIClient {
    
    let baseUrl = "https://api.openweathermap.org/data/2.5"
    static let shared = APIClient()
    
    // MARK: - Private methods
    
    private func makeRequest(
        request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    // MARK: - Instance methods
    
    func fetchCity(
        name: String,
        completion: @escaping (Result<FetchCityResponse?, Error>) -> Void
    ) {
        guard let string = URL(string: "\(baseUrl)/weather?q=\(name.replacingOccurrences(of: " ", with: "+"))&units=metric&appid=c6e381d8c7ff98f0fee43775817cf6ad") else {
            completion(.failure(NSError(domain: "missing string", code: 500, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: string, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        makeRequest(request: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let cities = try JSONDecoder().decode(FetchCityResponse.self, from: data)
                    completion(.success(cities))
                } catch {
                    completion(.failure(NSError(domain: "City Not Found", code: 400, userInfo: nil)))
                }
            }
        }
    }
    
    func fetchCity(
        loc: CLLocation,
        completion: @escaping (Result<FetchCityResponse?, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseUrl)/weather?lat=\(loc.coordinate.latitude)&lon=\(loc.coordinate.longitude)&units=metric&appid=c6e381d8c7ff98f0fee43775817cf6ad") else {
            completion(.failure(NSError(domain: "missing string", code: 500, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        makeRequest(request: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let cities = try JSONDecoder().decode(FetchCityResponse.self, from: data)
                    completion(.success(cities))
                } catch {
                    completion(.failure(NSError(domain: "City Not Found", code: 400, userInfo: nil)))
                }
            }
        }
    }
    
    func fetchForecast(
        city: FetchCityResponse,
        completion: @escaping (Result<ForecastResponse?, Error>) -> Void
    ) {
        guard let url = URL(
                string: "\(baseUrl)/forecast/daily?lat=\(city.coord.lat)&lon=\(city.coord.lon)&units=metric&cnt=5&appid=c6e381d8c7ff98f0fee43775817cf6ad") else {
            completion(.failure(NSError(domain: "missing string", code: 500, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        makeRequest(request: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
                
            else if let data = data {
                let forecast = try? JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(forecast))
            }
        }
    }
}
