//
//  BusLine.swift
//  travel
//
//  Created by Patrick Weaver on 8/2/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

struct BusLine {
    let name: String
    let variants: [BusLineVariant]
}

struct BusLineVariant {
    let busLine: BusLine
    let variantName: String
    let origin: BusStop
    let destination: BusStop
}
