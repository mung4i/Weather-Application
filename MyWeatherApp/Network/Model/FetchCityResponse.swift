//
//  FetchCityResponse.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation

// MARK: - FetchCityResponse
struct FetchCityResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
public struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

public extension Weather {
    enum WeatherType: String {
        case cloudy = "cloudy"
        case sunny = "sunny"
        case rainy = "rainy"
    }
    
    var type: WeatherType {
        if weatherDescription.contains("clear") || weatherDescription.contains("sky") {
            return .sunny
        } else if weatherDescription.contains("cloud") {
            return .cloudy
        } else if weatherDescription.contains("rain") {
            return .rainy
        } else {
            return .sunny
        }
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

