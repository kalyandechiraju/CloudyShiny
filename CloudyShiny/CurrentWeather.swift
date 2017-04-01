//
//  CurrentWeather.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 31/03/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
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
    
    func downloadWeatherData(completed: @escaping DownloadComplete) {
        print("location: \(Location.sharedInstance.latitude) \(Location.sharedInstance.longitude)")
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=\(APP_ID)")
        Alamofire.request(weatherURL!).responseJSON { response in
            let result = response.result
            if let value = result.value {
                let data = JSON(value)
                if let name = data["name"].string {
                    self._cityName = name
                }
                if let weather = data["weather"].array?[0]["main"].string {
                    self._weatherType = weather
                }
                if let temperature = data["main"]["temp"].double {
                    self._currentTemp = temperature - 273.15
                }
            }
            completed()
//            if let dict = result.value as? Dictionary<String, AnyObject> {
//                if let name = dict["name"] as? String {
//                    self._cityName = name.capitalized
//                }
//                
////                if let weather = dict["weather"]?[0]?["main"] as? String {
////                    self._weatherType = weather
////                }
//            }
        }
    }
}
