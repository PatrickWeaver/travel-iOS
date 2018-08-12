//
//  formatting.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/12/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func countdownFromTimeInSeconds(timeUntil: Int?) -> String {
    guard let timeUntil = timeUntil else {
        return ""
    }
    let intInterval = Int(timeUntil)
    if intInterval < 1 {
        return "Arriving or late"
    }
    let hours = intInterval / 3600
    var hoursString = "\(hours):"
    if hours == 0 {
        hoursString = ""
    }
    
    let minutes = (intInterval % 3600) / 60
    var minutesString = "\(minutes):"
    if minutes < 10, hours > 0 {
        minutesString = "0\(minutesString)"
    }
    
    let seconds = (intInterval % 3600) % 60
    var secondsString = String(seconds)
    if seconds < 10 {
        secondsString = "0\(secondsString)"
    }
    let el = "\(hoursString)\(minutesString)\(secondsString)"
    return el
}
