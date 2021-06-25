//
//  ForecastResponse.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
}

// MARK: - List
struct List: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg, clouds: Int
    let pop: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg, clouds, pop
    }
}

extension List {
    var descriptions: [String: Any] {
        [
            "Humidity": self.humidity,
            "Rain Chances": self.weather[0].weatherDescription,
            "Wind Speed": self.speed
        ]
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

extension Date {
    
    func getNextDate(current: Int) -> String {
        let today = dayofTheWeek
        let currentIndex = daysOfTheWeek.firstIndex(of: today) ?? 0
        
        var currentToLast: [String] = Array(daysOfTheWeek[currentIndex...daysOfTheWeek.count - 1])
        let firstToCurrent = Array(daysOfTheWeek[0...currentIndex])
        
        currentToLast.append(contentsOf: firstToCurrent)
        return currentToLast[current]
    }
    
    var dayofTheWeek: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        return daysOfTheWeek[dayNumber - 1]
    }
    
    private var daysOfTheWeek: [String] {
        return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }
}
