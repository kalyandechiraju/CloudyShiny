//
//  Location.swift
//  CloudyShiny
//
//  Created by Kalyan Dechiraju on 01/04/17.
//  Copyright © 2017 Codelight Studios. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
