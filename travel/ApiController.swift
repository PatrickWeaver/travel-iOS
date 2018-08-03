//
//  ApiController.swift
//  travel
//
//  Created by Patrick Weaver on 8/2/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func getBusRoutes() {
    let discoveryUrl = "https://mta-api.glitch.me/api/bus/routes"
    makeApiCall(to: discoveryUrl, then: parseBusRoutes)
}

func parseBusRoutes(_ responseData: Data?) -> String {
    guard let responseData = responseData else {
        return ""
    }
    
    do {
        let apiData = try JSONDecoder().decode(BusDiscoveryBlob.self, from: responseData)
        print(apiData)
        return "Done"
    } catch {
        print(error)
        return "{Error: ''}"
    }
}

func makeApiCall(to apiUrl: String, then whenFinished: @escaping ((_ respondWith: Data?) -> String)) -> Void {

    
    // Check that URL is valid and convert to URL type
    guard let url = URL(string: apiUrl) else {
        print("Error: Invalid URL")
        whenFinished(nil)
        return
    }

    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

        // Check for error
        guard let responseData = data else {
            guard let error = error else {
                print("Unknown Error")
                whenFinished(nil)
                return
            }
            print(error)
            whenFinished(nil)
            return
        }
        
        whenFinished(responseData)
        return
    }).resume()
}



/*
 guard let url = URL(string: busEndpoint) else {
 print("Error: Url Error")
 return
 }
 
 URLSession.shared.dataTask(with: url) { (data, response, error) in
 // check error
 
 guard let resData = data else {
 print("Error: data error")
 return
 }
 
 //let dataAsString = String(data: resData, encoding: .utf8)!
 //print(dataAsString)
 
 do {
 let busData = try JSONDecoder().decode(BusDataBlob.self, from: resData)
 //print("Line Ref: \(busData.jsonSiri.serviceDelivery.stopMonitoringDelivery[0].monitoredStopVisits[0].monitoredVehicleJourney.lineRef)")
 
 let incomingBussesData = busData.jsonSiri.serviceDelivery.stopMonitoringDelivery[0].monitoredStopVisits
 self.incomingBusses = [Bus]()
 for bus in incomingBussesData {
 let journey = bus.monitoredVehicleJourney
 let distances = journey.monitoredCall.extensions?.distances
 let newBus = Bus(
 id: UUID.init(),
 descriptiveDistance: (distances?.descriptive)!,
 metersAway: (distances?.metersAway)!,
 stopsAway: (distances?.stopsAway)!,
 secondsAway: journey.monitoredCall.timeUntilArrivalInSeconds,
 destinationId: journey.destinationId,
 destinationName: journey.destinationName
 )
 self.incomingBusses.append(newBus)
 }
 
 /*
 for bus in self.incomingBusses {
 print(bus)
 print("")
 }
 */
 DispatchQueue.main.async {
 self.runBusCountdownTimer()
 self.nextBussesTable.reloadData()
 self.refreshButton.isHidden = false
 self.loadingMessage.isHidden = true
 }
 
 
 } catch {
 print("Catch Block: \(error)")
 }
 
 }.resume()
 
 */

