//
//  ClassNameProtocol.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation
import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension UIViewController: ClassNameProtocol {}
extension UIView: ClassNameProtocol {}
