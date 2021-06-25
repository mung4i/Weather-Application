//
//  MapLocationController.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import MapKit
import UIKit

protocol MapLocationControllerDelegate: class {
    func didSelectLocation(_ location: CLLocation)
}

class MapLocationController: UIViewController {
    
    // MARK: - Instance Properties
    
    var delegate: MapLocationControllerDelegate?
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Overriden Instance Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.mapView)
        let location = mapView.convert(point, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didSelectLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
    }
}


extension MapLocationController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}
