//
//  BusStop.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

struct BusStop {
    let stopId: String
    let mtaId: String
    let latitude: Double
    let longitude: Double
    var distance: Double
    var milesAway: Double {
        return distance * 0.000621371
    }
    //let inUse: Bool
    let wheelchairBoarding: String // Bool
    //let routes: [Route]
    let intersectionName: String
    let travelDirection: String // Direction
}

/* JSON Parsing */

struct BusLineDiscoveryBlob: Decodable {
    let statusCode: Int?
    let currentUnixTime: Int? // Time?
    let busLineData: BusLineData?
    let statusMessage: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case currentUnixTime = "currentTime"
        case busLineData = "data"
        case statusMessage = "text"
        case version
    }
}

struct BusLocationDiscoveryBlob: Decodable {
    let statusCode: Int?
    let currentUnixTime: Int? // Time?
    let busLocationData: BusLocationData?
    let statusMessage: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case currentUnixTime = "currentTime"
        case busLocationData = "data"
        case statusMessage = "text"
        case version
    }
}

struct BusLineData: Decodable {
    let entry: BusLineEntry?
    let references: BusLineReferences?
    
    enum CodingKeys: String, CodingKey {
        case entry
        case references
    }
}

struct BusLocationData: Decodable {
    let limitExceeded: Bool?
    let stops: [BusDiscoveryStop?]
    //let outOfRange: Bool?
    //let references: [Any?]?
    
    enum CodingKeys: String, CodingKey {
        case limitExceeded
        case stops
        //case outOfRange
        //case references
    }
}

struct BusLineEntry: Decodable {
    // let polylines: [any?]
    let routeId: String?
    let stopGroupings: [StopGroupings?]
    let stopIds: [String?]
    
    enum CodingKeys: String, CodingKey {
        case routeId
        case stopGroupings
        case stopIds
    }
}

struct StopGroupings: Decodable {
    let ordered: Bool?
    // This is not really an array of StopGroups, there is a "type"
    // property at the end of the array, not sure how to parse that.
    let stopGroups: [StopGroup]
    
    enum CodingKeys: String, CodingKey {
        case ordered
        case stopGroups
    }
}

struct StopGroup: Decodable {
    let id: String?
    let name: StopGroupingName?
    // let polylines: [String]
    let stopIds: [String?]
    // let subGroups: [Sting]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        // case polylines
        case stopIds
        // case subGroups
    }
}

struct StopGroupingName: Decodable {
    let name: String?
    let names: [String]?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case names
        case type
    }
}

struct BusLineReferences: Decodable {
    //let agencies: [any?]
    //let routes: [any?]
    //let situations: [any?]
    let stops: [BusDiscoveryStop?]
    
    enum CodingKeys: String, CodingKey {
        //case agencies
        //case routes
        //case situations
        case stops
    }
}

struct BusDiscoveryStop: Decodable {
    let stopId: String?
    let direction: String? // Direction
    let mtaId: String?
    let lat: Double?
    let locationType: Int?
    let long: Double?
    let intersectionName: String?
    let routeIds: [String?]?
    let routes: [BusLocationDiscoveryLine?]?
    let wheelchairBoarding: String?
    
    enum CodingKeys: String, CodingKey {
        case stopId = "code"
        case direction
        case mtaId = "id"
        case lat
        case locationType
        case long = "lon"
        case intersectionName = "name"
        case routeIds
        case routes
        case wheelchairBoarding
    }
}

struct BusLocationDiscoveryLine: Decodable {
    let agency: BusLocationDiscoveryAgency?
    let color: String?
    let description: String?
    let id: String?
    let longName: String?
    let shortName: String?
    let textColor: String?
    let type: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case agency
        case color
        case description
        case id
        case longName
        case shortName
        case textColor
        case type
        case url
    }
}

struct BusLocationDiscoveryAgency: Decodable {
    let disclaimer: String?
    let mtaId: String?
    let lang: String?
    let agencyName: String?
    let phone: String?
    let privateService: Bool?
    let timezone: String?
    let url: String?
    
    
    enum CodingKeys: String, CodingKey {
        case disclaimer
        case mtaId = "id"
        case lang
        case agencyName = "name"
        case phone
        case privateService
        case timezone
        case url
    }
}


