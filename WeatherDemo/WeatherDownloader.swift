//
//  WeatherDownloader.swift
//  WeatherDemo
//
//  Created by Panyushenko on 14.04.2018.
//  Copyright © 2018 Artyom Panyushenko. All rights reserved.
//

import Foundation

class WeatherDownloader {
    static let sharedInstance = WeatherDownloader()
    
    let session = URLSession(configuration: .default)
    
    func requestWeather(latitude: Double, longitude: Double, completion: @escaping (_ weatherData: WeatherData) -> Void) {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constance.OpenWeatherMap.apiKey)&lang=ru") else { return }
        //download
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            
            let city = json?["name"] as? String
            let type = (json?["weather"] as? [[String: Any]])?[0]["description"] as? String
            let temp = (json?["main"] as? [String: Any])?["temp"] as? Double
            
            // Вернуть данные WeatherData
            // выполнение в главное потоке
            DispatchQueue.main.async {
                 completion(WeatherData(city: city, type: type, temperature: temp))
            }
        }
        dataTask.resume()
    }
}
