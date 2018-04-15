//
//  WeatherDownloader3.swift
//  WeatherDemo
//
//  Created by Panyushenko on 16.04.2018.
//  Copyright © 2018 Artyom Panyushenko. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WeatherDownloader3 {
    static let sharedInstance = WeatherDownloader3()
    
    let sessionManger = Alamofire.SessionManager.default
    
    func requestWeather(latitude: Double, longitude: Double, completion: @escaping (_ weatherData: WeatherData2) -> Void) {
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast") else {return}
        let parametr: [String: Any] = ["lat": latitude, "lon": longitude, "appid":Constance.OpenWeatherMap.apiKey, "lang": "ru"]
        sessionManger.request(url, method: .get, parameters: parametr).responseJSON { (dataResponse) in
            if case .success(let value) = dataResponse.result {
                let json = JSON(value)
                
                //let countRows = json["cnt"].int
                let countRows = json["list"].int
                let dateAndTime = json["list"][0]["dt"].string
                let typeWeather = json["list"][0]["weather"]["description"].string
                let temp = json["list"][0]["main"]["temp"].double
                let maxTemp = json["list"][0]["main"]["temp"].double
                let minTemp = json["list"][0]["main"]["temp"].double
                
//                let city = json["name"].string
//                let type = json["weather"][0]["description"].string
//                let temp = json["main"]["temp"].double
                
                DispatchQueue.main.async {
                    completion(WeatherData2(countRows: countRows, dateAntTime: dateAndTime, type: typeWeather, temperature: temp, maxTemperature: maxTemp, minTemperature: minTemp))
                }
            }
        }
    }
}
