//
//  CityController.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 24/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class CityController: BaseViewController {
    
    // MARK: - Instance Properties
    
    private let disposeBag = DisposeBag()
    
    private let detailsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    private let forecastLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }()

    var viewModel: CityViewModel?
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    // MARK: - Overriden Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionViews()
        self.configureCityInfo()
        self.configureIsLoading()
        self.viewModel?.fetchForecast()
    }
    
    // MARK: - Private Instance Methods
    
    private func configureCityInfo() {
        guard let city = self.viewModel?.city, let weather = city.weather.first else { return }
        
        setupViewDesign(weather: weather)
        temperatureLabel.text = "\(Int(city.main.temp)) ℃"
        weatherDescriptionLabel.text = weather.type.rawValue.uppercased()
    }
    
    private func configureIsLoading() {
        self.viewModel?.isLoading.asObservable().subscribe{ (event) in
            let isLoading = event.element ?? false
            
            if isLoading {
                self.view.addBlurView()
            } else {
                self.detailsCollectionView.reloadData()
                self.removeBlurView()
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupCollectionViews() {
        detailsCollectionView.collectionViewLayout = detailsLayout
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        detailsCollectionView.register(
            .init(nibName: DetailsCollectionViewCell.className, bundle: nil),
            forCellWithReuseIdentifier: DetailsCollectionViewCell.className
        )
        
        forecastCollectionView.collectionViewLayout = forecastLayout
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
        forecastCollectionView.register(
            .init(nibName: ForecastCell.className, bundle: nil),
            forCellWithReuseIdentifier: ForecastCell.className
        )
    }
    
    private func setupViewDesign(weather: Weather) {
        switch weather.type {
        case .cloudy:
            view.backgroundColor = UIColor.cloudyColor
            backgroundImage.image = UIImage(named: "forest_cloudy")
            detailsCollectionView.backgroundColor = UIColor.cloudyColor
            forecastCollectionView.backgroundColor = UIColor.cloudyColor
        case .rainy:
            view.backgroundColor = UIColor.rainyColor
            backgroundImage.image = UIImage(named: "forest_rainy")
            detailsCollectionView.backgroundColor = UIColor.rainyColor
            forecastCollectionView.backgroundColor = UIColor.rainyColor
        case .sunny:
            view.backgroundColor = UIColor.sunnyColor
            backgroundImage.image = UIImage(named: "forest_sunny")
            detailsCollectionView.backgroundColor = UIColor.sunnyColor
            forecastCollectionView.backgroundColor = UIColor.sunnyColor
        }
    }
}

extension CityController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let detailsSize: CGSize = CGSize( width: collectionView.bounds.width, height: 40)
        let forecastSize: CGSize = CGSize(width: collectionView.bounds.width, height: 80)

        return collectionView == detailsCollectionView ? detailsSize : forecastSize
    }
}

extension CityController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = self.viewModel, let lists = vm.list else { return .init() }
        
        if collectionView == forecastCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.className, for: indexPath) as! ForecastCell
            cell.configureForecastCell(temp: lists[indexPath.row].temp)
            return cell
        }
        
        else if collectionView == detailsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.className, for: indexPath) as! DetailsCollectionViewCell
            cell.configureCell(details: lists[indexPath.row], row: indexPath.row)
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = self.viewModel, let list = vm.list else { return 0 }
        return collectionView == detailsCollectionView ? list.count : 1
    }    
}
