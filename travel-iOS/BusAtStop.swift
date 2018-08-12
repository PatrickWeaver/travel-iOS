//
//  BusAtStop.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

struct BusAtStop {
    //let bus: Bus
    //let stop: BusStop
    var arrivalProximityText: String
    var metersAway: Int
    var stopsAway: Int
    var arrivals: [Arrival]
    var secondsAway: Int? {
        if arrivals.count > 0 {
            guard let arrival = arrivals.last else {
                return 9999999999
            }
            let expectedArrival = arrival.expectedArrival
            return intervalFromDateTime(dt: expectedArrival)
        } else {
            return 9999999999
        }
    }
    var arrivalCountdown: String {
        return countdownFromTimeInSeconds(timeUntil: secondsAway)
    }
}

struct Arrival {
    //let timestamp: Date?
    //let arrivalTime: Date?
    //var actualArrival: Date?
    //var accuracyInSeconds: Double
    var expectedArrival: Date?
}


/* JSON Parsing */

struct BusDataBlob: Decodable {
    let jsonSiri: JsonSiri?
    
    enum CodingKeys: String, CodingKey {
        case jsonSiri = "Siri"
    }
}


struct JsonSiri: Decodable {
    let serviceDelivery: ServiceDelivery?
    
    enum CodingKeys: String, CodingKey {
        case serviceDelivery = "ServiceDelivery"
    }
}

struct ServiceDelivery: Decodable {
    let responseTimestamp: String? // Datetime
    let stopMonitoringDelivery: [StopMonitoringDelivery]
    //let situationExchangeDelivery: [SituationExchangeDelivery]
    
    enum CodingKeys: String, CodingKey {
        case responseTimestamp = "ResponseTimestamp"
        case stopMonitoringDelivery = "StopMonitoringDelivery"
        //case situationExchangeDelivery = "SituationExchangeDelivery"
    }
}

struct StopMonitoringDelivery: Decodable {
    let responseTimestamp: String? // Datetime
    let monitoredStopVisits: [MonitoredStopVisit]
    let validUntil: String? // Datetime
    
    enum CodingKeys: String, CodingKey {
        case responseTimestamp = "ResponseTimestamp"
        case monitoredStopVisits = "MonitoredStopVisit"
        case validUntil = "ValidUntil"
    }
}

struct MonitoredStopVisit: Decodable {
    let monitoredVehicleJourney: MonitoredVehicleJourney?
    let recordedAtTime: String? // Datetime
    
    enum CodingKeys: String, CodingKey {
        case monitoredVehicleJourney = "MonitoredVehicleJourney"
        case recordedAtTime = "RecordedAtTime"
    }
}

struct MonitoredVehicleJourney: Decodable {
    let lineRef: String?
    var directionString: String?
    // let FramedVehicleJourney
    let journeyPattern: String?
    let lineName: [String]
    let lineOperator: String?
    let originId: String? // BusStop.id
    let destinationId: String? // BusStop.id
    let destinationName: [String] // BusStop.name
    //let situations: // Not sure what this is used for
    var monitored: Bool?
    var location: VehicleLocation? // Location
    var bearing: Double?
    var progressRate: String? // ProgressRate
    let blockRef: String?
    let vehicleId: String? // Vehicle
    let monitoredCall: MonitoredCall?
    //let onwardCalls: OnwardCall
    
    enum CodingKeys: String, CodingKey {
        case lineRef = "LineRef"
        case directionString = "DirectionRef"
        //case framedVehicleJourney = "FramedVehicleJourneyRef"
        case journeyPattern = "JourneyPatternRef"
        case lineName = "PublishedLineName"
        case lineOperator = "OperatorRef"
        case originId = "OriginRef"
        case destinationId = "DestinationRef"
        case destinationName = "DestinationName"
        //case situations = "SituationRef"
        case monitored = "Monitored"
        case location = "VehicleLocation"
        case bearing = "Bearing"
        case progressRate = "ProgressRate" // ProgressRate
        case blockRef = "BlockRef"
        case vehicleId = "VehicleRef"
        case monitoredCall = "MonitoredCall"
        // case onwardCalls = "OnwardCalls"
    }
}

struct VehicleLocation: Decodable {
    var lat: Double?
    var long: Double?
    
    enum CodingKeys: String, CodingKey {
        case lat = "Latitude"
        case long = "Longitude"
    }
}

struct MonitoredCall: Decodable {
    let expectedArrivalTime: String? // Datetime
    var timeUntilArrivalInSeconds: Int? {
        return intervalFromDateTime(dt: dateFromDatetimeString(dt: expectedArrivalTime))
    }
    let arrivalProximityText: String?
    let expectedDepartureTime: String? //Datetime
    let metersAway: Int?
    let stopsAway: Int?
    let stopPointId: String?
    let visitNumber: Int?
    let stopPointName: [String]
    
    enum CodingKeys: String, CodingKey {
        case expectedArrivalTime = "ExpectedArrivalTime"
        case arrivalProximityText = "ArrivalProximityText"
        case expectedDepartureTime = "ExpectedDepartureTime"
        case metersAway = "DistanceFromStop"
        case stopsAway = "NumberOfStopsAway"
        case stopPointId = "StopPointRef"
        case visitNumber = "VisitNumber"
        case stopPointName = "StopPointName"
    }
}

struct OnwardCall: Decodable {
    
}
