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
    
    
    func makeRequest(request: URLRequest,create: String)  -> [Contact]  {
        
        var info = [Contact]()
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error")
                return
            }
            
     
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
          
            
            //print("DAAAAAAATTTTAAAAAAA: \(data as NSData)") //<-`as NSData` is useful for debugging
            do {
                
               let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
               print("Json: \(json)")
                
            if create == "tabContact"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
               
                if let dictionary = json as? [[String: Any]]{
                
                    
                    
                    for index in 0...dictionary.count - 1 {
                        
                    info = info + [Contact(login: dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: dictionary[index]["idUser"] as! Int)]
                        
                    
                    }
                    
                   
               }
                
                
                }
           
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            //let responseString = String(data: data, encoding: .utf8) ?? ""
            //completion(???)
        }
        
        task.resume()
        
        return info
        
    }
    
    
    
    
    init(){
        
        //self.urldonne = urldonne
        //self.create = create
        //self.cellInfo = cellInfo
        //self.cellInfo = makeRequest(request: URLRequest(url: URL(string: urldonne)!), create: create)
        //print(cellInfo.count)
        //print(cellInfo)
        
    }


 }
