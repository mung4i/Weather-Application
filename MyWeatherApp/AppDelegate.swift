//
//  AppDelegate.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .glossyBlack
        UINavigationBar.appearance().tintColor = .white
        return true
    }
     
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.saveContext()
    }
}

