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

struct BusDiscoveryBlob: Decodable {
    let code: Int?
    let currentTime: Int?
    let data: BusDiscoveryData?
    let text: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case code
        case currentTime
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

