//
//  BusLineViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/6/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit
import CoreLocation

class BusLineViewController: UITableViewController, CLLocationManagerDelegate {
    
   
    
    var busLine: BusLine?
    var busStops = [BusStop]()
    var routeGroupings = [[String]]()
    var routeGroupingNames = [String]()
    var routeStops = [[BusStop]]()
    
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

    @IBOutlet weak var shortName: UILabel!
    @IBOutlet var busLineTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Bus Stops"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //self.locationManager.requestWhenInUseAuthorization()
        startReceivingLocationChanges()
        location = locationManager.location ?? CLLocation(latitude: 40.6892009, longitude: -73.9739544)
        print("* * * * * * *")
        print(location.coordinate)
        
        getBusStops(by: busLine, then: parseBusStops)
        var busLineShortName: String
        if  busLine != nil {
            busLineShortName = busLine!.shortName
        } else {
            busLineShortName = "NO DATA"
        }
        shortName.text = busLineShortName
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return routeStops.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return routeGroupingNames[section]
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routeStops[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopCell") as? BusStopCell else {
            print("Can't assign cell")
            return UITableViewCell()
        }
        let stop = routeStops[indexPath.section][indexPath.row]
        cell.stopId.text = stop.stopId
        cell.intersection.text = stop.intersectionName
        //print("\(stop.distance) meters / \(stop.milesAway) miles")
        if (stop.milesAway < 0.2) {
            cell.stopDistance.text = "\(((stop.milesAway * 100).rounded(.up)/100)) miles away"
        } else {
            cell.stopDistance.text = "\(((stop.milesAway * 10).rounded(.up)/10)) miles away"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let rowSection = indexPath.section
            let selectedRow = indexPath.row
            if let detailVC = segue.destination as? BusAtStopTableViewController {
                if (self.busLine != nil) {
                    detailVC.stopRoutes.append(self.busLine!)
                }
                detailVC.busStop = self.routeStops[rowSection][selectedRow]
            }
        }
    }
    
    
    
    func parseBusStops(_ responseData: Data?) -> Void {
        guard let responseData = responseData else {
            return
        }
        
        do {
            let apiData = try JSONDecoder().decode(BusLineDiscoveryBlob.self, from: responseData)
            //print(apiData)
            guard var lastRefreshed = apiData.currentUnixTime else { return }
            
            guard let discoveryLineData = apiData.busLineData else { return }
            
            // Get mtaIds along route and store in routeGroupings:
            guard let busLineEntryData = discoveryLineData.entry else { return }
            
            guard let busLineStopGroupings = busLineEntryData.stopGroupings[0] else { return }
            
            for busLineStopGrouping in busLineStopGroupings.stopGroups {
                var groupingName = ""
                if ((busLineStopGrouping.name) != nil) {
                    groupingName = busLineStopGrouping.name!.name ?? ""
                }
                routeGroupingNames.append(groupingName)
                
                var busStopIdArray = [String]()
                for busStopId in busLineStopGrouping.stopIds {
                    if busStopId != nil  {
                        busStopIdArray.append(busStopId!)
                    }
                }
                routeGroupings.append(busStopIdArray)
            }
            
            
            // Get all BusStops on route and store in BusStops
            guard let busLineReferenceData = discoveryLineData.references else { return }
            for discoveryStop in busLineReferenceData.stops {
                guard let discoveryStop = discoveryStop else { return }
                let busStop = BusStopFromDiscoveryBusStop(discoveryStop, location)
                busStops.append(busStop)
            }
            
            // Find each BusStop from the ordered routeGroupings Groups
            for stopGroup in routeGroupings {
                var busStopArray = [BusStop]()
                for stopId in stopGroup {
                    for stop in busStops {
                        if stopId == stop.mtaId {
                            busStopArray.append(stop)
                            break
                        }
                    }
                }
                routeStops.append(busStopArray)
            }

            DispatchQueue.main.async {
                self.busLineTableView.reloadData()
            }
            
            return
        } catch {
            print("Catch: Line")
            print(error)
            return
        }
    }
    
    /*
    func findBusStopFrom(mtaId: String) -> BusStop {
        
    }
    */


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
