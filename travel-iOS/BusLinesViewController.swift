//
//  ViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit
import CoreLocation

class BusLinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var nearbyStops = [BusStop]()
    var nearbyStopRoutes = [String]()
    var busLines = [[BusLine]]()
    
    var locationManager = CLLocationManager()
    var location = CLLocation(latitude: 0.0, longitude: 0.0)
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return busLines.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Nearby Stops"
        case 1:
            return "Brooklyn"
        case 2:
            return "The Bronx"
        case 3:
            return "Manhattan"
        case 4:
            return "Queens"
        case 5:
            return "Staten Island"
        case 6:
            return "Express"
        default:
            return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return nearbyStops.count
        } else {
            return busLines[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLocationStopCell") as? BusLocationStopTableViewCell else {
                return UITableViewCell()
            }
            let stop = nearbyStops[indexPath.row]
            cell.routes.text = nearbyStopRoutes[indexPath.row]
            cell.intersection.text = stop.intersectionName
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLineCell") as? BusLineCell else {
                return UITableViewCell()
            }
            cell.shortName.text = busLines[indexPath.section - 1][indexPath.row].shortName
            cell.longName.text = busLines[indexPath.section - 1][indexPath.row].longName
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBusRoutes()
        startReceivingLocationChanges()
        location = locationManager.location ?? CLLocation(latitude: 40.6892009, longitude: -73.9739544)
        getBusStops(by: location, then: parseLocationStops)
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if indexPath.section > 0 {
                if let detailVC = segue.destination as? BusLineViewController {
                    detailVC.busLine = self.busLines[indexPath.section - 1][indexPath.row]
                }
            } else {
                if let detailVC = segue.destination as? BusAtStopTableViewController {
                    detailVC.busStop = self.nearbyStops[indexPath.row]
                }
            }
        }
    }

    
    func getBusRoutes() {
        let discoveryUrl = "https://mta-api.glitch.me/api/bus/routes"
        makeApiCall(to: discoveryUrl, then: parseBusRoutes)
    }
    
    
    func parseBusRoutes(_ responseData: Data?) -> Void {
        
        guard let responseData = responseData else {
            print("no response data to parse")
            return
        }
        print(responseData)
        
        do {
            let apiData = try JSONDecoder().decode(BusLinesDiscoveryBlob.self, from: responseData)
            print(apiData)
            guard var lastRefreshed = apiData.currentUnixTime else {
                print("NO TIME")
                return
                
            }
            guard let discoveryData = apiData.data else { return }
            for busDiscoveryLine in discoveryData.list {
                guard let busDiscoveryLine = busDiscoveryLine else { return }
                var busLine = BusLineFromBusDiscoveryLine(busDiscoveryLine)
                
                for i in 0...6 {
                    var section = [BusLine]()
                    busLines.append(section)
                }
                
                if busLine.shortName.range(of: "Bx") != nil {
                    self.busLines[1].append(busLine)
                } else if busLine.shortName.range(of: "M") != nil {
                    self.busLines[2].append(busLine)
                } else if busLine.shortName.range(of: "Q") != nil {
                    self.busLines[3].append(busLine)
                } else if busLine.shortName.range(of: "X") != nil {
                    self.busLines[5].append(busLine)
                // Put B and S at the end because of "SBS"
                } else if busLine.shortName.range(of: "S") != nil {
                    self.busLines[4].append(busLine)
                } else if busLine.shortName.range(of: "B") != nil {
                    self.busLines[0].append(busLine)
                } else {
                    busLine.shortName = "*\(busLine.shortName)"
                    self.busLines[6].append(busLine)
                }
            }
            
            for i in 0...6 {
                if i == 1 {
                    self.busLines[i].sort(by: { getLineNumber(from: $0, withOffset: 2) < getLineNumber(from: $1, withOffset: 2) })
                } else {
                    self.busLines[i].sort(by: { getLineNumber(from: $0, withOffset: 1) < getLineNumber(from: $1, withOffset: 1) })
                }
            }
            
            func getLineNumber(from busLine: BusLine, withOffset offset: Int) -> Int {
                let str = busLine.shortName
                let index = str.index(str.startIndex, offsetBy:offset)
                let subStr = str.suffix(from: index)
                guard let lineNumber = Int(subStr) else {
                    return 0
                }
                return lineNumber
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            return
        } catch {
            print("CATCH: Lines")
            print(error)
            return
        }
    }
    
    func parseLocationStops(_ responseData: Data?) -> Void {
        guard let responseData = responseData else {
            print("no response data to parse")
            return
        }
        print(responseData)
        
        do {
            let apiData = try JSONDecoder().decode(BusLocationDiscoveryBlob.self, from: responseData)
            //print(apiData)
            
            guard let stopsData = apiData.busLocationData else {
                print("No stops data")
                return
            }
            
            
            for stop in stopsData.stops {
                guard let stop = stop else {
                    print("Error logging stop ids")
                    return
                }
                print(stop.stopId ?? "")
                
                guard let routesArray = stop.routes else {
                    print("No routes array")
                    return
                }
                let routes = routesArray.reduce("") {a, b in "\(a)\(b!.shortName!) "}
                nearbyStopRoutes.append(routes)
                
                let busStop = BusStopFromDiscoveryBusStop(stop, location)
                
                nearbyStops.append(busStop)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            return
        } catch {
            print("Catch: Stops Location")
            print(error)
            return
        }
    }
}

