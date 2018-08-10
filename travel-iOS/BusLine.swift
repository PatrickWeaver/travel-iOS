//
//  BusLine.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

struct BusLine {
    let id: UUID
    let agencyId: String
    let color: String
    let description: String
    let lineId: String
    let longName: String
    let shortName: String
    let textColor: String
    let scheduleUrl: String
    //let variants: [BusLineVariant]
}

struct BusLineVariant {
    let busLine: BusLine
    let variantName: String
    let origin: BusStop
    let destination: BusStop
}




/* Json Parsing */

// Bus Lines
struct BusLinesDiscoveryBlob: Decodable {
    let code: Int?
    let currentUnixTime: Int?
    let data: BusDiscoveryData?
    let text: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case code
        case currentUnixTime = "currentTime"
        case data
        case text
        case version
    }
}

struct BusDiscoveryData: Decodable {
    let limitedExceeded: Bool?
    let list: [BusDiscoveryLine]?
}

struct BusDiscoveryLine: Decodable {
    let agencyId: String?
    let color: String?
    let description: String?
    let id: String?
    let longName: String?
    let shortName: String?
    let textColor: String?
    let type: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case agencyId
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

// Bus Line

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
}

struct BusLineReferences: Decodable {
    
}

struct StopGroupings: Decodable {
    
}



