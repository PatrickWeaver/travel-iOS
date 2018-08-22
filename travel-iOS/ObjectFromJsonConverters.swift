//
//  ObjectFromJsonConverters.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation
import CoreLocation

func BusLineFromBusDiscoveryLine(_ discoveryLine: BusDiscoveryLine) -> BusLine {

    return BusLine(
        id: UUID.init(),
        agencyId: discoveryLine.agencyId ?? "",
        color: discoveryLine.color ?? "",
        description: discoveryLine.description ?? "",
        lineId: discoveryLine.id ?? "",
        longName: discoveryLine.longName ?? "",
        shortName: discoveryLine.shortName ?? "",
        textColor: discoveryLine.textColor ?? "",
        scheduleUrl: discoveryLine.url ?? ""
    )
}

func BusStopFromDiscoveryBusStop(_ discoveryStop: BusDiscoveryStop, _ location: CLLocation) -> BusStop {
    
    let latitude = discoveryStop.lat ?? 0.0
    let longitude = discoveryStop.long ?? 0.0
    let stopLocation = CLLocation(latitude: latitude, longitude: longitude)
    let distance = location.distance(from: stopLocation)
    
    return BusStop(
        stopId: discoveryStop.stopId ?? "0",
        mtaId: discoveryStop.mtaId ?? "MTA_0",
        latitude: latitude,
        longitude: longitude,
        distance: distance,
        wheelchairBoarding: discoveryStop.wheelchairBoarding ?? "UNKNOWN",
        intersectionName: discoveryStop.intersectionName ?? "",
        travelDirection: discoveryStop.direction ?? ""
    )
}

func BusAtStopFromMonitoredCall(_ monitoredCall: MonitoredCall) -> BusAtStop {
    
    let arrival = Arrival(
        expectedArrival: dateFromDatetimeString(dt: monitoredCall.expectedArrivalTime)
    )
    let arrivals = [arrival]
    
    return BusAtStop(
        arrivalProximityText: monitoredCall.arrivalProximityText ?? "Unknown",
        metersAway: monitoredCall.metersAway ?? 999999999,
        stopsAway: monitoredCall.stopsAway ?? 99999,
        arrivals: arrivals
    )
}
