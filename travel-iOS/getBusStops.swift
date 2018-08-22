//
//  getBusStops.swift
//  travel-iOS
//
//  Created by PW on 8/21/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func getBusStops(_ busLine: BusLine?, then whenFinished: @escaping ((_ respondWith: Data?) -> Void)) {
    guard let busLine = busLine else {
        return
    }
    let discoveryUrl = "https://mta-api.glitch.me/api/bus/routes/\(busLine.shortName)"
    makeApiCall(to: discoveryUrl, then: whenFinished)
}
