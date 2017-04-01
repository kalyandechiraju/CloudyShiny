//
//  Forecast.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 31/03/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Forecast {
    private var _date: String!
    private var _weatherType: String!
    private var _lowTemp: Double!
    private var _highTemp: Double!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var lowTemp: Double {
        if _lowTemp == nil {
            _lowTemp = 0.0
        }
        return _lowTemp
    }
    
    var highTemp: Double {
        if _highTemp == nil {
            _highTemp = 0.0
        }
        return _highTemp
    }
    
    init(data: JSON) {
        if let dt = data["dt"].double {
            let unixDate = Date(timeIntervalSince1970: dt)
            self._date = unixDate.dayOfWeek()
        }
        if let minTemp = data["temp"]["min"].double {
            self._lowTemp = minTemp - 273.15
        }
        if let maxTemp = data["temp"]["max"].double {
            self._highTemp = maxTemp - 273.15
        }
        if let type = data["weather"].array?[0]["main"].string {
            self._weatherType = type
        }
    }
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
