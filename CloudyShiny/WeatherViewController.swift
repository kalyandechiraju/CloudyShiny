//
//  WeatherViewController.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 30/03/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let forecastCellIdentifier = "ForecastCell"
    var currentWeather: CurrentWeather!
    var forecasts = [Forecast]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
    }
    
    func startDownloadingWeatherInfo() {
        self.currentWeather.downloadWeatherData {
            // Update UI
            self.updateUI()
        }
        self.downloadForeCastData {
            // Update UI
            if self.forecasts.count > 0 {
                self.forecasts.remove(at: 0)
            }
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .denied) {
            // The user denied authorization
        } else if (status == .authorizedWhenInUse) {
            // The user accepted authorization
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            self.startDownloadingWeatherInfo()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: forecastCellIdentifier, for: indexPath) as? ForecastCell {
            cell.configureCell(forecast: forecasts[indexPath.row])
            return cell
        } else {
            return ForecastCell()
        }
    }
    
    func updateUI() {
        dateLabel.text = currentWeather.date
        temperatureLabel.text = "\(Int(currentWeather.currentTemp))"
        conditionLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        weatherIcon.image = UIImage(named: currentWeather.weatherType)
    }
    
    func downloadForeCastData(completed: @escaping DownloadComplete) {
        let forecastURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=6&appid=\(APP_ID)")
        Alamofire.request(forecastURL!).validate().responseJSON { response in
            if let result = response.result.value {
                let data = JSON(result)
                if let list = data["list"].array {
                    for obj in list {
                        let forecast = Forecast(data: obj)
                        self.forecasts.append(forecast)
                    }
                }
            }
            completed()
        }
    }

}

