//
//  ViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class BusLinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var busLines = [[BusLine]]()
    //var b = [BusLine]()
    //var bx = [BusLine]()
    //var m = [BusLine]()
    //var q = [BusLine]()
    //var s = [BusLine]()
    //var x = [BusLine]()
    //var sections = [[BusLine]]()
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return busLines.count
    }
    
    /*
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["B", "BX", "M", "Q", "S", "E", ""]
    }
    */
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Brooklyn"
        case 1:
            return "The Bronx"
        case 2:
            return "Manhattan"
        case 3:
            return "Queens"
        case 4:
            return "Staten Island"
        case 5:
            return "Express"
        default:
            return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busLines[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLineCell") as? BusLineCell else {
            return UITableViewCell()
        }
        cell.shortName.text = busLines[indexPath.section][indexPath.row].shortName
        cell.longName.text = busLines[indexPath.section][indexPath.row].longName
        return cell
    }
    
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
            if let detailVC = segue.destination as? BusLineViewController {
                detailVC.busLine = self.busLines[indexPath.section][indexPath.row]
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
}

