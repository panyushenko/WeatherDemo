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
    
    var countRowsForCell: Int?
    var dateAntTimeForCell: String?
    var typeForCell: String?
    var temperatureForCell: Double?
    var maxTemperatureForCell: Double?
    var minTemperatureForCell: Double?
    
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
        
        WeatherDownloader2.sharedInstance.requestWeather(latitude: coordinates.latitude, longitude: coordinates.longitude) { [weak self] (weatherData) in
            self?.updateUI(weatherData: weatherData)
        }
    }

    func updateUI(weatherData: WeatherData){
        citeLabel.text = weatherData.city
        weatherDescriptionLabel.text = weatherData.type
        if let temp = weatherData.temperature {
            temperatureLabel.text = "\(temp - 273.15) ℃"
        }
    }
    
    func loadWeatherAndUpdateUI2() {
        guard let coordinates = locationManager.location?.coordinate else { return }
        
        WeatherDownloader3.sharedInstance.requestWeather(latitude: coordinates.latitude, longitude: coordinates.longitude) { [weak self] (weatherData2) in
            self?.updateUI2(weatherData2: weatherData2)
        }
    }
    
    func updateUI2(weatherData2: WeatherData2){
        countRowsForCell = weatherData2.countRows
        dateAntTimeForCell = weatherData2.dateAntTime
        typeForCell = weatherData2.type
        temperatureForCell = weatherData2.temperature
        maxTemperatureForCell = weatherData2.maxTemperature
        minTemperatureForCell = weatherData2.minTemperature
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadWeatherAndUpdateUI2()
        
        guard let countRowsForCell = countRowsForCell  else { return 0 }
        return countRowsForCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        return cell
    }
    
    
}
