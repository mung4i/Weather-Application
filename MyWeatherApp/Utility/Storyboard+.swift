//
//  Storyboard+.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Storyboard : String {
    case main = "Main"
}

fileprivate extension UIStoryboard {
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }

    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: App View Controllers

extension UIStoryboard {
    class func loadCityController() -> CityController {
        return loadFromMain(CityController.className) as! CityController
    }
    
    class func loadHelpController() -> HelpController {
        return loadFromMain(HelpController.className) as! HelpController
    }
    
    class func loadMapController() ->  MapLocationController {
        return loadFromMain(MapLocationController.className) as! MapLocationController
    }
}
