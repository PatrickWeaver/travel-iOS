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


/* JSON Parsing */

struct BusDataBlob: Decodable {
    let jsonSiri: JsonSiri
    
    enum CodingKeys: String, CodingKey {
        case jsonSiri = "Siri"
    }
}


struct JsonSiri: Decodable {
    let serviceDelivery: ServiceDelivery
    
    enum CodingKeys: String, CodingKey {
        case serviceDelivery = "ServiceDelivery"
    }
}

struct ServiceDelivery: Decodable {
    let responseTimestamp: String // Datetime
    let stopMonitoringDelivery: [StopMonitoringDelivery]
    
    enum CodingKeys: String, CodingKey {
        case responseTimestamp = "ResponseTimestamp"
        case stopMonitoringDelivery = "StopMonitoringDelivery"
    }
}

struct StopMonitoringDelivery: Decodable {
    let responseTimestamp: String // Datetime
    let monitoredStopVisits: [MonitoredStopVisit]
    let validUntil: String // Datetime
    
    enum CodingKeys: String, CodingKey {
        case responseTimestamp = "ResponseTimestamp"
        case monitoredStopVisits = "MonitoredStopVisit"
        case validUntil = "ValidUntil"
    }
}

struct MonitoredStopVisit: Decodable {
    let monitoredVehicleJourney: MonitoredVehicleJourney
    let recordedAtTime: String // Datetime
    
    enum CodingKeys: String, CodingKey {
        case monitoredVehicleJourney = "MonitoredVehicleJourney"
        case recordedAtTime = "RecordedAtTime"
    }
}

struct MonitoredVehicleJourney: Decodable {
    let lineRef: String
    var directionString: String
    // let FramedVehicleJourney
    let journeyPattern: String
    let lineName: String
    let lineOperator: String
    let originId: String // BusStop.id
    let destinationId: String // BusStop.id
    let destinationName: String // BusStop.name
    //let situations: // Not sure what this is used for
    var monitored: Bool
    var location: VehicleLocation // Location
    var bearing: Double
    var progressRate: String // ProgressRate
    let blockRef: String
    let vehicleId: String // Vehicle
    let monitoredCall: MonitoredCall
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
    var lat: Double
    var long: Double
    
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
    let expectedDepartureTime: String? //Datetime
    let extensions: MonitoredCallExtension?
    let stopPointId: String?
    let visitNumber: Int?
    let stopPointName: String?
    
    enum CodingKeys: String, CodingKey {
        case expectedArrivalTime = "ExpectedArrivalTime"
        case expectedDepartureTime = "ExpectedDepartureTime"
        case extensions = "Extensions"
        case stopPointId = "StopPointRef"
        case visitNumber = "VisitNumber"
        case stopPointName = "StopPointName"
    }
}

struct MonitoredCallExtension: Decodable {
    let distances: MonitoredCallDistances
    
    enum CodingKeys: String, CodingKey {
        case distances = "Distances"
    }
}

struct MonitoredCallDistances: Decodable {
    let descriptive: String
    let metersAway: Double
    let stopsAway: Int
    let metersAlongRoute: Double
    
    enum CodingKeys: String, CodingKey {
        case descriptive = "PresentableDistance"
        case metersAway = "DistanceFromCall"
        case stopsAway = "StopsFromCall"
        case metersAlongRoute = "CallDistanceAlongRoute"
    }
}

struct OnwardCall: Decodable {
    
}
