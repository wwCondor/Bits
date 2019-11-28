//
//  Coordinate.swift
//  'Bits
//
//  Created by Wouter Willebrands on 27/11/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
