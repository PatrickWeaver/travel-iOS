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

struct BusLineData: Decodable {
    let entry: BusLineEntry?
    let references: BusLineReferences?
    
    enum CodingKeys: String, CodingKey {
        case entry
        case references
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
    let routeIds: [String?]
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
        case wheelchairBoarding
    }
}


