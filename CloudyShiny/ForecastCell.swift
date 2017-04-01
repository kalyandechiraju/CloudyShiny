//
//  ForecastCell.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 01/04/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(forecast: Forecast) {
        dayLabel.text = forecast.date
        weatherTypeLabel.text = forecast.weatherType
        maxLabel.text = "\(Int(forecast.highTemp))"
        minLabel.text = "\(Int(forecast.lowTemp))"
        weatherIcon.image = UIImage(named: forecast.weatherType)
    }
}
