//
//  ViewConnexion.swift
//  TP5
//
//  Created by m2sar on 02/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation

import UIKit

class ConnectionView: UIViewController {
    
    
    
    var url: String = ""
    var cellInfo = [Contact]()
    var dictionary = [[String: Any]()]
    static var token = String()
    static var idUser = Int()
    static var cellInfo = [Contact]()
    static var Historique = -1
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var TextMail: UITextField!
    @IBOutlet weak var TextMdp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func connect(_ sender: UIButton) {
        
        
        ConnectionView.Historique = -1
        ConnectionView.idUser = Int()
        ConnectionView.token = String()
        ConnectionView.cellInfo = [Contact]()
        
        self.url = "http://178.62.22.140:8080/api/public/account/login?email=" + TextMail.text! + "&mdp=" + TextMdp.text!
        var request = URLRequest(url: URL(string: self.url)!);
        request.httpMethod = "POST";
        self.makeRequest(request: request, create: "access", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
      
        
    }
    
    @IBAction func SignUp(_ sender: AnyObject) {
        
        let signUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpView")
        
        
        //self.present(signUpView, animated: true, completion: nil) //montre sans bouton back
        //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>) // sortir du present
        
        self.navigationController?.pushViewController(signUpView, animated: true) //montre avec un bouton back
        //self.popoverPresentationController // sortir du push
        

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func makeRequest(request: URLRequest,create: String, row: Int){
        
        
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in guard let data = data, error == nil else{
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
                    
                    self.dictionary = json as! [[String: Any]]//{
                    
                    if self.dictionary.count >= 1{
                        
                        for index in 0...self.dictionary.count - 1 {
                            
                            if self.dictionary[index]["idRecepteur"] as! Int != ConnectionView.idUser {
                                
                                ConnectionView.cellInfo = ConnectionView.cellInfo + [Contact(login: self.dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idRecepteur"] as! Int)]
                                
                                
                            }else{
                                
                                self.cellInfo = self.cellInfo + [Contact(login: self.dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idDemandeur"] as! Int)]
                                
                                
                            }
                            
                        }

                    }
                 }
                    
                if create == "access"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    
                    self.dictionary = [json as! [String: Any]]//{
                    
                    if self.dictionary.count >= 1{
                        
                       for index in 0...self.dictionary.count - 1 {
                            
                            ConnectionView.token = self.dictionary[index]["token"] as! String
                            print("token: \(ConnectionView.token)")
                            ConnectionView.idUser = self.dictionary[index]["id"] as! Int

                        
                        }

                        
                        DispatchQueue.main.async {
                            if ConnectionView.token != "erreur"{
                                
                                print(ConnectionView.idUser)
                                print(ConnectionView.token)
                                
                                
                                let premierTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremierTab")
                                
                                
                               
                                self.present(premierTab, animated: true, completion: nil) //montre sans bouton back
                                //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>) sortir du present
                                
                                //self.navigationController?.pushViewController(mapView, animated: true) //montre avec un bouton back
                                //self.popoverPresentationController sortir du push

                                
                                
                            }
                            
                            
                            
                            
                            if ConnectionView.token == "erreur"{
                                
                                self.TextMdp.text = ""
                                print("False Login and/or Password")
                                
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
        
        
        
        
        
        
        task.resume()
        
    }

    
        
    
}
