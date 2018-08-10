//
//  ViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusLinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLineCell") as? BusLineCell else {
            return UITableViewCell()
        }
        cell.shortName.text = busLines[indexPath.row].shortName
        cell.longName.text = busLines[indexPath.row].longName
        return cell
    }

    var busLines = [BusLine]()
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBusRoutes()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            if let detailVC = segue.destination as? BusLineViewController {
                detailVC.busLine = self.busLines[selectedRow]
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
        
        do {
            let apiData = try JSONDecoder().decode(BusLinesDiscoveryBlob.self, from: responseData)
            guard var lastRefreshed = apiData.currentUnixTime else {
                print("NO TIME")
                return
                
            }
            guard let discoveryData = apiData.data else { return }
            for busDiscoveryLine in discoveryData.list {
                guard let busDiscoveryLine = busDiscoveryLine else { return }
                let busLine = BusLineFromBusDiscoveryLine(busDiscoveryLine)
                self.busLines.append(busLine)
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
}

