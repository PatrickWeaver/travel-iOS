//
//  Bus.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func dateFromDatetimeString(dt: String?) -> Date? {
    guard let dtS = dt else {
        return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZ"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: -04 * 3600)
    return dateFormatter.date(from: dtS)
}

func intervalFromDateTime(dt: Date?) -> Int? {
    guard let interval = dt?.timeIntervalSinceNow else {
        return nil
    }
    return Int(interval)
}

func countdownFromTimeInSeconds(timeUntilArrival: Int?) -> String {
    guard let timeUntilArrival = timeUntilArrival else {
        return ""
    }
    let intInterval = Int(timeUntilArrival)
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



/*
 class BusCell: NSObject, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return 5
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = UITableViewCell()
 cell.textLabel?.text = "\(self.milesAway) miles away"
 return cell
 }
 }
 */

struct Bus {
    var id: UUID = UUID.init()
    var descriptiveDistance: String = ""
    var metersAway: Double?
    var milesAway: Double? {
        guard let meters = metersAway else {
            return nil
        }
        return meters * 0.000621371
    }
    var stopsAway: Int?
    var secondsAway: Int?
    var minutesAway: Double? {
        guard let seconds = secondsAway else {
            return nil
        }
        return Double(seconds) / 60.0
    }
    var destinationId: String? // Destination
    var destinationName: String? // Destination
    var arrivalCountdown: String {
        return countdownFromTimeInSeconds(timeUntilArrival: secondsAway)
    }
}


