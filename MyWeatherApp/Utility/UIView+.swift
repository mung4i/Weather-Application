//
//  UIView+.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style = .actionSheet, action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action ?? defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UIView {
    
    func addBlurView() {
        let effectView = UIBlurEffect(style: .light)
        
        let blurView = UIVisualEffectView(effect: effectView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
            self.addSubview(blurView)
        })
        
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) { activityIndicator.style = .medium }
        else { activityIndicator.style = .gray }
        
        activityIndicator.color = UIColor.black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            blurView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.125),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.125),
            blurView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.125),
            activityIndicator.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.125)
        ])
        
        blurView.layer.cornerRadius = 5
        blurView.layer.masksToBounds = true
        
        activityIndicator.startAnimating()
    }
    
    func removeBlurView() {
        self.subviews.forEach { (view) in
            guard view.isKind(of: UIVisualEffectView.self) else { return }
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
                view.removeFromSuperview()
            })
        }
    }
}

extension UIImage {
    func resizeImg(toSize size: CGSize, scale: CGFloat) -> UIImage? {
        let imgRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: imgRect)
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImg
    }
}

