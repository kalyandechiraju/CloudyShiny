//
//  CurrentWeather.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 31/03/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherData(completed: DownloadComplete) {
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=bangalore&appid=\(APP_ID)")
        Alamofire.request(weatherURL!).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
//                if let weather = dict["weather"]?[0]?["main"] as? String {
//                    self._weatherType = weather
//                }
            }
        }
        completed()
    }
}
