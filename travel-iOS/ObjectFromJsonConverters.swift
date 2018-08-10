//
//  ObjectFromJsonConverters.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func BusLineFromBusDiscoveryLine(_ discoveryLine: BusDiscoveryLine) -> BusLine {

    return BusLine(id: UUID.init(), agencyId: discoveryLine.agencyId!, color: discoveryLine.color!, description: discoveryLine.description!, lineId: discoveryLine.id!, longName: discoveryLine.longName!, shortName: discoveryLine.shortName!, textColor: discoveryLine.textColor!, scheduleUrl: discoveryLine.url!)
}

func BusStopFromDiscoveryBusStop(_ discoveryStop: BusDiscoveryStop) -> BusStop {
    return BusStop(mtaId: discoveryStop)
}
