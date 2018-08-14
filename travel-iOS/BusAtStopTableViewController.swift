//
//  BusAtStopTableViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/10/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusAtStopTableViewController: UITableViewController {
    
    var busLine: BusLine?
    var busStop: BusStop?
    var trackedBusses = [BusAtStop]()
    
    @IBOutlet weak var busStopIntersection: UILabel!
    @IBOutlet var busAtStopTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrackedBusses()
        var intersection: String
        if  busStop != nil {
            intersection = busStop!.intersectionName
        } else {
            intersection = "NO DATA"
        }
        busStopIntersection.text = intersection
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return trackedBusses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusAtStopCell") as? BusAtStopCell else {
            print("Can't assign cell")
            return UITableViewCell()
        }
        let trackedBus = trackedBusses[indexPath.row]
        
        
        var countdown = ""
        if (trackedBus.arrivalCountdown != nil) {
            countdown = "\(trackedBus.arrivalCountdown!)\n"
        }
        
        var milesAway = ""
        if trackedBus.arrivalProximityText.range(of: "miles") == nil {
            milesAway = "\(((trackedBus.milesAway * 10).rounded(.up)/10)) miles away\n"
        }
        
        var stopsAway = ""
        if trackedBus.arrivalProximityText.range(of: "stop") == nil {
            if trackedBus.stopsAway != 1 {
                stopsAway = "\(trackedBus.stopsAway) stops away"
            } else {
                stopsAway = "\(trackedBus.stopsAway) stop away"
            }
        }
        
        let arrivalProximityText = "\(trackedBus.arrivalProximityText)\n\(countdown)\(milesAway)\(stopsAway)"
        
        cell.arrivalProximityText.text = arrivalProximityText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func getTrackedBusses() {
        guard let busStop = busStop, let busLine = busLine else {
            return
        }
        let realTimeUrl = "https://mta-api.glitch.me/api/bus/\(busLine.shortName)/\(busStop.stopId)"
        print(realTimeUrl)
        makeApiCall(to: realTimeUrl, then: parseTrackedBusses)
    }
    
    func parseTrackedBusses(_ responseData: Data?) -> Void {
        guard let responseData = responseData else {
            return
        }
        
        do {
            let apiData = try JSONDecoder().decode(BusDataBlob.self, from: responseData)
            //print(apiData)
            guard let jsonSiri = apiData.jsonSiri else { return }
            guard let serviceDelivery = jsonSiri.serviceDelivery else { return }
            guard let lastRefreshed = serviceDelivery.responseTimestamp else { return } // Need to parse this other API returns Unix Time
            if (serviceDelivery.stopMonitoringDelivery.count == 1) {
                let stopMonitoringDelivery = serviceDelivery.stopMonitoringDelivery[0]
                guard let validUntil = stopMonitoringDelivery.validUntil else { return }
                let monitoredStopVisits = stopMonitoringDelivery.monitoredStopVisits
                for visit in monitoredStopVisits {
                    
                    guard let monitoredVehicleJourney = visit.monitoredVehicleJourney else { return }
                    // Do something with all this bus data
                    // Maybe add BusJourney object
                    guard let monitoredCall = monitoredVehicleJourney.monitoredCall else {
                        return
                    }
                    print(monitoredCall)
                    let busAtStop = BusAtStopFromMonitoredCall(monitoredCall)
                    print(busAtStop)
                    trackedBusses.append(busAtStop)
                    print("")
                }
                
                DispatchQueue.main.async {
                    self.runBusCountdownTimer()
                    self.busAtStopTableView.reloadData()
                }
                
            } else {
                print("Stop Monitoring Delivery not 1 \(serviceDelivery.stopMonitoringDelivery.count)")
            }
        } catch {
            print("Catch: Line")
            print(error)
            return
        }
    }
    
    var isTimerRunning = false
    func runBusCountdownTimer() {
        if (!isTimerRunning){
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.updateTimer()
            })
            //Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    func updateTimer() {
        self.busAtStopTableView.reloadData()
    }
    
    

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
