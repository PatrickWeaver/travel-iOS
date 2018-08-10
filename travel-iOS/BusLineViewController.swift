//
//  BusLineViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/6/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusLineViewController: UITableViewController {
    
    var busLine: BusLine?
    var busStops = [BusStop]() // Set?
    var routeGroupings = [String]()
    var routeStops = [BusStop]()

    @IBOutlet weak var shortName: UILabel!
    @IBOutlet var busLineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getBusStops()
        let busLineShortName: String
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Number of Stops: \(routeGroupings.count)")
        return routeGroupings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopCell") as? BusStopCell else {
            print("Can't assign cell")
            return UITableViewCell()
        }
        let stop = routeStops[indexPath.row]
        cell.stopId.text = stop.stopId
        cell.intersection.text = stop.intersectionName
        
         /*
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLineCell") as? BusLineCell else {
         return UITableViewCell()
         }
         cell.shortName.text = busLines[indexPath.row].shortName
         cell.longName.text = busLines[indexPath.row].longName
         */
        
        return cell
    }
    
    func getBusStops() {
        guard let busLine = busLine else {
            return
        }
        let discoveryUrl = "https://mta-api.glitch.me/api/bus/\(busLine.shortName)"
        makeApiCall(to: discoveryUrl, then: parseBusStops)
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
            for busStopId in busLineEntryData.stopIds {
                guard let busStopId = busStopId else { return }
                routeGroupings.append(busStopId)
            }
            
            // Get all BusStops on route and store in BusStops
            guard let busLineReferenceData = discoveryLineData.references else { return }
            for discoveryStop in busLineReferenceData.stops {
                guard let discoveryStop = discoveryStop else { return }
                let busStop = BusStopFromDiscoveryBusStop(discoveryStop)
                busStops.append(busStop)
            }
            
            // Find each BusStop from the ordered routeGroupings
            for stopId in routeGroupings {
                for stop in busStops {
                    if stopId == stop.mtaId {
                        routeStops.append(stop)
                        break
                    }
                }
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
