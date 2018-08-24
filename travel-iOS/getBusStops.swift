//
//  getBusStops.swift
//  travel-iOS
//
//  Created by PW on 8/21/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation
import CoreLocation

func getBusStops(by busLine: BusLine?, then whenFinished: @escaping ((_ respondWith: Data?) -> Void)) {
    guard let busLine = busLine else {
        return
    }
    let discoveryUrl = "https://mta-api.glitch.me/api/bus/routes/\(busLine.shortName)"
    makeApiCall(to: discoveryUrl, then: whenFinished)
}

func getBusStops(by location: CLLocation, then whenFinished: @escaping ((_ respondWith: Data?) -> Void)) {
    print("LAT: \(location.coordinate.latitude)")
    print("LONG: \(location.coordinate.longitude)")
    
    let locationUrl = "https://mta-api.glitch.me/api/bus/location?lat=\(location.coordinate.latitude)&long=\(location.coordinate.longitude)"
    print(locationUrl)
    makeApiCall(to: locationUrl, then: whenFinished)
}
