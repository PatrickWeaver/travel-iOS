//
//  ApiController.swift
//  travel-iOS
//
//  Created by Patrick Weaver on 8/9/18.
//  Copyright © 2018 Patrick Weaver. All rights reserved.
//

import Foundation

func makeApiCall(to apiUrl: String, then whenFinished: @escaping ((_ respondWith: Data?) -> Void)) -> Void {
    
    // Check that URL is valid and convert to URL type
    guard let url = URL(string: apiUrl) else {
        print("Error: Invalid URL")
        whenFinished(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
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
        }.resume()
}
