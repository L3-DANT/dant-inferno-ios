//
//  SearchView.swift
//  TP5
//
//  Created by m2sar on 10/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UITableViewController, UISearchBarDelegate {
    
    var url: String = ""
    var cellInfo = [Contact]()
    var dictionary = [[String: Any]]()
    
    @IBOutlet var SearchTableView: UITableView!
    
    @IBOutlet weak var searchBar1: UISearchBar!
    
    
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        
        searchBar1.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellInfo.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mycell") //my cell is the identifier
        
        cell.textLabel?.text = cellInfo[indexPath.row].login  //"Test"
        //        cell.accessoryType = .checkmark
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //crée un bouton delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Ajouter", handler: { (action, indexPath) in
            
            // The UIAlertControllerStyle ActionSheet is used when there are more than one button.
            
            func myHandler(alert: UIAlertAction){
                
                //changer en demande d'ami
                
               
                self.url = "http://178.62.22.140:8080/api/contact/ajout?idUser=" + String(ConnectionView.idUser)  + "&idAjoute=" + String(describing: self.cellInfo.remove(at: indexPath[1]).idRecepteur) + "&token=" + ConnectionView.token
                var request = URLRequest(url: URL(string: self.url)!);
                request.httpMethod = "PUT";
                self.makeRequest(request: request, create: "suppression", row: indexPath.row) //le parametre create permet de déterminer ce que le résultat de la requete sera
                
                //self.cellInfo.remove(at: indexPath.row)
                tableView.reloadData()
                print("You tapped: \(alert.title)")
            }
            
            let otherAlert = UIAlertController(title: "Voulez vous envoyer une demande d'ami à cette personne?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            
            let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
            
            let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(callFunction)
            otherAlert.addAction(dismiss)
            
            self.present(otherAlert, animated: true, completion: nil)
            
            
            //envoi l'effacement du contact à la BDD
            
            
        })
        ]
    }
    
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        dictionary.removeAll()
        cellInfo.removeAll()
        
        url = "http://178.62.22.140:8080/api/contact/search?pseudo=" + searchText
        
        makeRequest(request: URLRequest(url: URL(string: url)!), create: "tabContact", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    
                    self.dictionary = json as! [[String: Any]]//{
                    
                    if self.dictionary.count >= 1{
                        
                        for index in 0...self.dictionary.count - 1 {
                            
                            self.cellInfo = self.cellInfo + [Contact(login: self.dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idUser"] as! Int)]
                                    self.tableView.reloadData()
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                    
                            
                            
                            
                        }
                        
                        
                    }
                    
                   
                }
                
                
                if create == "suppression"{
                    
                    
                    
                    self.cellInfo.remove(at: row)
                    self.tableView.reloadData()
                    
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
