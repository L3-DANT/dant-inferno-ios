//
//  SignUpView.swift
//  TP5
//
//  Created by m2sar on 03/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//
import Foundation
import UIKit

var url: String = ""
var cellInfo = [Contact]()
var dictionary = [[String: Any]]()


class SignUpView: UITableViewController {
    @IBOutlet weak var validationButton: UIButton!
    
    @IBOutlet weak var ecritureText: UITextField!
    
    @IBOutlet weak var mdpText: UITextField!
    @IBOutlet weak var disp: UILabel!
    
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var confirmationText: UITextField!
    @IBAction func ecriture(_ sender: Any) {
        
        
        disp.text = "Disponible"
        
        dictionary.removeAll()
        cellInfo.removeAll()
        
        url = "http://178.62.22.140:8080/api/contact/search?pseudo=" + ecritureText.text!
        
        makeRequest(request: URLRequest(url: URL(string: url)!), create: "tabContact", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
        
        
        
        
    }
    
    @IBAction func Valider(_ sender: Any) {
        
        
            if mailText.text != ""{
                if mdpText.text != ""{
                    if ecritureText.text != ""{
                    if disp.text == "Disponible"{

               url = "http://178.62.22.140:8080/api/public/account/new?email=" + String(describing: mailText.text) + "&pseudo=" + String(describing: ecritureText.text) + "&mdp=" + String(describing: mdpText.text)
            var request = URLRequest(url: URL(string: url)!);
            request.httpMethod = "PUT";
         
            
            makeRequest(request: URLRequest(url: URL(string: url)!), create: "tabContact", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
            

            
        }else{
        
        
        ecritureText.text = ""
            
            
                        }
                    }
                }
        }
    }
    
    
    func makeRequest(request: URLRequest,create: String, row: Int){
        
        
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
                    
                    dictionary = json as! [[String: Any]]//{
                    
                    if dictionary.count >= 1{
                        
                        for index in 0...dictionary.count - 1 {
                            
                            cellInfo = cellInfo + [Contact(login: dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: dictionary[index]["idUser"] as! Int)]
                            
                            
                            
                            if cellInfo.count == 0{
                                
                                self.disp.text = "Disponible"
                                
                            }else{
                                
                                self.disp.text = "Indisponible"
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            
            
            //let responseString = String(data: data, encoding: .utf8) ?? ""
            //completion(???)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        task.resume()
        
        
    }
    
}
