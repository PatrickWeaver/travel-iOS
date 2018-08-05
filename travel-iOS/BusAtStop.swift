//
//  BusAtStop.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

struct BusAtStop {
    let bus: Bus
    let stop: BusStop
    var expectedArrivals: [ExpectedArrival]
    var actualArrival: Date
    
}

struct ExpectedArrival {
    let timestamp: Date
    let arrivalTime: Date
    var accuracyInSeconds: Double
}
