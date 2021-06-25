//
//  BaseViewController.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Overriden Instance Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.statusBarBackgroundColor = .glossyBlack
    }
    
    // MARK: - Instance Methods
    
    func navigationItemFactory(action: Selector, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .clear
        
        return UIBarButtonItem(customView: button)
    }
    
    func removeBlurView() {
        DispatchQueue.main.async {
            self.view.removeBlurView()
        }
    }
}
