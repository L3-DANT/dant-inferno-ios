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
    var create: String
    
    func makeRequest(request: URLRequest,create: String, completion: @escaping (String)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            //print("DAAAAAAATTTTAAAAAAA: \(data as NSData)") //<-`as NSData` is useful for debugging
            do {
                var json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("JJJJSSSSSOOOOOONNNNNNNN: \(json)")
                
                
                if create == "tabContact"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    
                    print("TRANSFORMATION TABCONTACt...............................")
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data)
                    } catch {
                        print(error)
                    }
                    guard let item = (json as AnyObject) as? [String: Any],
                        let pseudo = item["pseudo"] as? [String: Any],
                        let idRecepteur = item["idRecepteur"] as? Int else {
                            return
                    }
                    
                    print("pseudo: \(pseudo)")
                    print("idRecepteur: \(idRecepteur)")
                    

                    
                    
                    
                }
                
                
                
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            //Not sure what you mean with "i need to return the json as String"
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(responseString)
        }
        task.resume()
    }
    
    
    

    
    init(urldonne: String, create: String) {
        
        self.urldonne = urldonne
        self.create = create
        
        makeRequest(request: URLRequest(url: URL(string: urldonne)!), create: create) { (result : String?) in
            if let result = result {
                print("got result: \(result)")
            }
            
        }
        
    }
 }


