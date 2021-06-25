//
//  Date+.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation

struct DateISO: Codable {
    var date: Date
}

extension Date {
    
    static func timeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 0 && hour < 12 {
            return "Good Morning"
        } else if hour >= 12 && hour < 18 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale.current
        
        return dateFormatter
    }
    
    static func formatDate(date: Date, format: String = "h:mm a") -> String {
        return Date.dateFormatter.string(from: date)
    }
    
    static func formatDate(str: String, format: String = "h:mm a") -> String {
        
        if let date = Date.dateFormatter.date(from: str) {
            let newDf = DateFormatter()
            newDf.dateFormat = format
            return newDf.string(from: date)
        }
        
        return ""
    }
}
