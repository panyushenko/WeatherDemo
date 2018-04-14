//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Panyushenko on 14.04.2018.
//  Copyright © 2018 Artyom Panyushenko. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var citeLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWeatherAndUpdateUI() {
        guard let coordinates = locationManager.location?.coordinate else { return }
        
        WeatherDownloader.sharedInstance.requestWeather(latitude: coordinates.latitude, longitude: coordinates.longitude) { [weak self] (weatherData) in
            self?.updateUI(weatherData: weatherData)
        }
    }

    func updateUI(weatherData: WeatherData){
        citeLabel.text = weatherData.city
        weatherDescriptionLabel.text = weatherData.type
        if let temp = weatherData.temperature {
            temperatureLabel.text = "\(temp - 273.15)"
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            loadWeatherAndUpdateUI()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        loadWeatherAndUpdateUI()
    }
}
