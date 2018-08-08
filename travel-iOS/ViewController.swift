//
//  ViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("BUS LINES COUNT: \(busLines.count)")
        return busLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusLineCell") as? BusLineCell else {
            print("ELSE! \(indexPath)")
            return UITableViewCell()
        }
        cell.shortName.text = busLines[indexPath.row].shortName
        cell.longName.text = busLines[indexPath.row].longName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let busLineViewController = mainStoryboard.instantiateViewController(withIdentifier: "BusLineViewController") as? BusLineViewController else { return }
        
        
        busLineViewController.busLine = busLines[indexPath.row]
        
        present(busLineViewController, animated: true, completion: nil)
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
    
    func getBusRoutes() {
        let discoveryUrl = "https://mta-api.glitch.me/api/bus/routes"
        makeApiCall(to: discoveryUrl, then: parseBusRoutes)
    }
    
    func parseBusRoutes(_ responseData: Data?) -> Void {
        guard let responseData = responseData else {
            return
        }
        
        do {
            let apiData = try JSONDecoder().decode(BusDiscoveryBlob.self, from: responseData)
            //print(apiData)
            
            guard var lastRefreshed = apiData.currentTime else { return }
            
            guard let discoveryData = apiData.data else { return }
            guard let busLinesListData = discoveryData.list else { return }
            for busDiscoveryLine in busLinesListData {
                let busLine = BusLineFromBusDiscoveryLine(busDiscoveryLine)
                self.busLines.append(busLine)
            }
            print("\(busLines[0].shortName): \(busLines[0].longName)")
            //print(busLines)
            print("BEFORE RELOADING")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("RELOADING")
            }
            
            return
        } catch {
            print(error)
            return
        }
    }
    
    func makeApiCall(to apiUrl: String, then whenFinished: @escaping ((_ respondWith: Data?) -> Void)) -> Void {
        
        
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


}

