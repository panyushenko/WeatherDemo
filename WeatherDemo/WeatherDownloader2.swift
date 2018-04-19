//
//  WeatherDownloader2.swift
//  WeatherDemo
//
//  Created by Panyushenko on 17.04.2018.
//  Copyright © 2018 Artyom Panyushenko. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WeatherDownloader2 {
    static let sharedInstance = WeatherDownloader2()
    
    let sessionManger = Alamofire.SessionManager.default
    
    func requestWeather(latitude: Double, longitude: Double, completion: @escaping (_ weatherData: WeatherData) -> Void) {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather") else { return }
        let parametrs: [String: Any] = ["lat": latitude,"lon": longitude,"appid": Constance.OpenWeatherMap.apiKey,"lang": "ru"]
        sessionManger.request(url, method: .get, parameters: parametrs).responseJSON { (dataResponse) in
            if case .success(let value) = dataResponse.result {
                let json = JSON(value)
                
                let city = json["name"].string
                let type = json["weather"][0]["description"].string
                let temp = json["main"]["temp"].double
                
                DispatchQueue.main.async {
                    completion(WeatherData(city: city, type: type, temperature: temp))
                }
            }
        }
    }
    func requestWeatherFiveDays(latitude: Double, longitude: Double, completion: @escaping (_ weatherData: WeatherDataFiveDayes) -> Void) {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast") else { return }
        let parametrs: [String: Any] = ["lat": latitude,"lon": longitude,"appid": Constance.OpenWeatherMap.apiKey]
        sessionManger.request(url, method: .get, parameters: parametrs).responseJSON { (dataResponse) in
            if case .success(let value) = dataResponse.result {
                let json = JSON(value)
                
                let cnt = json["cnt"].int
                
                guard let newCnt = cnt else {return}
                
                var arrayList = [[String: Any]]()
                for index in 0...newCnt {
                    let dateAndTime = json["list"][index]["dt_txt"].string
                    let temp = json["list"][index]["main"]["temp"].double
                    let type = json["list"][index]["weather"][0]["main"].string
                    //guard let newDateAndTime = dateAndTime, let newTemp = temp, let newType = type else {return}
                    if let newDateAndTime = dateAndTime, let newTemp = temp, let newType = type {
                        arrayList.append(["dt_txt": newDateAndTime, "temp": Int(newTemp - 273.15), "description": newType])
                    }
                }
                
//                for item in json["list"].arrayValue {
//                    let dateAndTime = item["dt_txt"].string
//                    let temp = item["main"]["temp"].double
//                    let type = item["weather"][0]["main"].string
//                }

//                let dateAndTime = json["list"][0]["dt_txt"].string
//                let temp = json["list"][0]["main"]["temp"].double
//                let type = json["list"][0]["weather"][0]["description"].string

                DispatchQueue.main.async {
                    //completion(WeatherDataFiveDayes(countRow: cnt))
                    completion(WeatherDataFiveDayes(list: arrayList))
                    //completion(WeatherDataFiveDayes(countRow: cnt, list: arrayList))
                    //completion(WeatherDataFiveDayes(countRow: cnt, temperature: temp, type: type, dateAndTime: dateAndTime))
                }
            }
        }
    }
}
