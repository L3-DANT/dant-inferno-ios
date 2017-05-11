//
//  AppelHttp.swift
//  TP5
//
//  Created by m2sar on 10/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import UIKit
import Foundation

class AppelHttp {
    
    var urldonne: String
    
    func makeRequest(request: URLRequest, completion: @escaping (String)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            print(data as NSData) //<-`as NSData` is useful for debugging
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                //Why don't you use decoded JSON object? (`json` may not be a `String`)
            } catch {
                print("error serializing JSON: \(error)")
            }
            //Not sure what you mean with "i need to return the json as String"
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(responseString)
        }
        task.resume()
    }
    
    
    
    init(urldonne: String) {
        
        self.urldonne = urldonne
        
        makeRequest(request: URLRequest(url: URL(string: urldonne)!)) { (result : String?) in
            if let result = result {
                print("got result: \(result)")
            }
            
        }
        
    }
 }


