//
//  WeatherDownloader2.swift
//  
//
//  Created by Panyushenko on 15.04.2018.
//

import Alamofire
import SwiftyJSON

class WeatherDownloader2 {
    static let sharedInstance = WeatherDownloader2()
    
    let sessionManager = Alamofire.SessionManager.default
    
    let session = URLSession(configuration: .default)
    
    func requestWeather(latitude: Double, longitude: Double, completion: @escaping (_ weatherData: WeatherData) -> Void) {
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather") else { return }
        let parametr: [String: Any] = ["lat": latitude, "lon": longitude, "appid": Constance.OpenWeatherMap.apiKey, "lang": "ru"]
        sessionManager.request(url, method: .get, parameters: parametr).responseJSON { (dataResponse) in
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
}

