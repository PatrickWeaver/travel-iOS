//
//  ViewController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/5/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var busLines = [BusLine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBusRoutes()
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
            print(apiData)
            
            guard var lastRefreshed = apiData.currentTime else { return }
            
            guard let discoveryData = apiData.data else { return }
            guard let busLinesListData = discoveryData.list else { return }
            //var row: Int = 0
            for busDiscoveryLine in busLinesListData {
                let busLine = BusLineFromBusDiscoveryLine(busDiscoveryLine)
                //row += 1
                DispatchQueue.main.async {
                    self.busLines.append(busLine)
                    //let indexPath = IndexPath(row: row, section: 0)
                    //self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
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

