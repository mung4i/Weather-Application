//
//  HomeController.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import CoreLocation
import UIKit

class HomeController: BaseViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Instance Properties
    
    let locationManager: CLLocationManager = .init()
    let viewModel: HomeViewModel = .init()
    
    // MARK: Private Instance Methods
    
    @objc
    private func addButtonTapped(sender: UIBarButtonItem) {
        let mapControllerVC = UIStoryboard.loadMapController()
        mapControllerVC.delegate = self
        
        self.navigationController?.pushViewController(mapControllerVC, animated: true)
    }
    
    @objc
    private func searchButtonTapped(sender: UIBarButtonItem) {
        let helpControllerVC = UIStoryboard.loadHelpController()
        self.navigationController?.pushViewController(helpControllerVC, animated: true)
    }
    
    private func setupNavigationBarItems() {
        let addImage = UIImage(named: "plus_image")
        let helpImage = UIImage(named: "Combined Shape")
        
        let resizedAddImage = addImage?.resizeImg(toSize: CGSize(width: 20, height: 20), scale: UIScreen.main.scale)
        let resizedHelpImage = helpImage?.resizeImg(toSize: CGSize(width: 20, height: 20), scale: UIScreen.main.scale)
        
        let addButtonItem = self.navigationItemFactory(action: #selector(addButtonTapped(sender:)), image: resizedAddImage)
        let helpButtonItem = self.navigationItemFactory(action: #selector(searchButtonTapped(sender:)), image: resizedHelpImage)
        self.navigationItem.rightBarButtonItems = [helpButtonItem, addButtonItem]
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {  self.tableView.reloadData() }
    }
    
    private func retrieveFavorites() {
        self.view.addBlurView()
        self.viewModel.retrieveFavorites { (result) in
            self.removeBlurView()
            switch result {
            case .failure: break
            case .success: self.reloadTableView()
            }
        }
    }
    
    private func updateLocation(byMap location: CLLocation) {
        self.view.addBlurView()
        viewModel.fetchCity(loc: location) { (result) in
            self.removeBlurView()
            
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.presentAlert(title: "Alert", message: "City Not Found")
                }
            case .success:
                self.reloadTableView()
            }
        }
    }
    
    private func updateLocation(location: CLLocation) {
        self.view.addBlurView()
        viewModel.fetchCity(loc: location) { (result) in
            self.removeBlurView()
            
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.presentAlert(title: "Alert", message: "City Not Found")
                }
            case .success:
                self.reloadTableView()
                DispatchQueue.main.async { self.retrieveFavorites() }
            }
        }
    }
    
    // MARK: - Overriden Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBlurView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchBar.delegate = self
        
        setupNavigationBarItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: FavoriteCityCell.className, bundle: nil), forCellReuseIdentifier: FavoriteCityCell.className)
        tableView.separatorStyle = .none
    }
}

// MARK: - Location Manager Delegate

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            self.updateLocation(location: location)
        }
    }
}

// MARK: - Location Manager Delegate
extension HomeController: MapLocationControllerDelegate {
    
    func didSelectLocation(_ location: CLLocation) {
        self.updateLocation(byMap: location)
    }
}

// MARK: - UITableView DataSource

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCityCell.className, for: indexPath) as? FavoriteCityCell else {
            return .init()
        }
        cell.configureCell(favorite: viewModel.favorites[indexPath.row])
        return cell
    }
}

// MARK: - UITableView Delegate

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityController = UIStoryboard.loadCityController()
        
        let viewModel = CityViewModel(city: self.viewModel.favorites[indexPath.row])
        cityController.viewModel = viewModel
        
        self.navigationController?.pushViewController(cityController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension HomeController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        guard searchBar.text != "" else { return }
        
        self.view.addBlurView()
        self.viewModel.fetchCity(name: searchBar.text ?? "") { (result) in
            self.removeBlurView()
            DispatchQueue.main.async { self.searchBar.text = "" }
            
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.presentAlert(title: "Alert", message: "City not found")
                }
            case .success:
                self.reloadTableView()
            }
        }
    }
}


