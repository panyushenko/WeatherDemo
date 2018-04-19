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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var citeLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var locationManager = CLLocationManager()

    var informWeatherArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()

        tableView.delegate = self
        tableView.dataSource = self
        
//        activityIndicatorView.startAnimating()
//        let data = []
//        var loadContent { data in
            self.activityIndicator.isHidden = true
//            self.data = data
//            self.tableView.reloadData()
//        }
        //activityIndicator.startAnimating()
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
        WeatherDownloader2.sharedInstance.requestWeatherFiveDays(latitude: coordinates.latitude, longitude: coordinates.longitude) { [weak self] (weatherDataFiveDays) in
            self?.update2UI(weatherDataFiveDays: weatherDataFiveDays)
        }
    }

    func update2UI(weatherDataFiveDays: WeatherDataFiveDayes) {
        informWeatherArray = weatherDataFiveDays.list
        tableView.reloadData()
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informWeatherArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if let date = informWeatherArray[indexPath.row]["date_txt"] {
            cell.dateLable.text = "\(date as! String)"
        }
        if let time = informWeatherArray[indexPath.row]["time_txt"] {
            cell.timeLabel.text = "\(time as! String)"
        }
        if let temperature = informWeatherArray[indexPath.row]["temp"] {
            cell.temperatureForFivesDaysLabel.text = "\(Int(temperature as! Double - 273.15))℃"
        }
        if let type = informWeatherArray[indexPath.row]["description"] {
            cell.iconeWeatherImage.image = UIImage(named: type as! String)
        }
        return cell
    }
}
