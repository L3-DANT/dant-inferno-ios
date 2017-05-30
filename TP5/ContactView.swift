//
//  ContactView.swift
//  TP5
//
//  Created by m2sar on 03/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation

import UIKit

class ContactView: UITableViewController {
    
    
    var url: String = ""
    var dictionary = [[String: Any]]()
    var cellInfo = [Contact]()
    
    
   
    @IBOutlet weak var DemandeButton: UIBarButtonItem!
    @IBOutlet weak var rechercheButton: UIBarButtonItem!
   @IBOutlet weak var UrlButton: UIButton!
    

    
    override func viewDidLoad() {
      
        
        self.url =  "http://178.62.22.140:8080/api/private/contact/liste/amis?idUser=" + String(ConnectionView.idUser) + "&token=" + ConnectionView.token
        
        self.makeRequest(request: URLRequest(url: URL(string: self.url)!), create: "tabContact", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
        
        
        
        super.viewDidLoad()
        self.tableView.reloadData()
        
        
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
        
        cell.textLabel?.text = cellInfo[indexPath.row].login + String(cellInfo[indexPath.row].idRecepteur)  //"Test"
        //        cell.accessoryType = .checkmark
        
        
    
        
        return cell
        
    }
    
    //met une checkMark sur la ligne selectionnée
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if cellInfo[indexPath.row].checkmark == true{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            cellInfo[indexPath.row].checkmark  = false
            
            
        }else{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            cellInfo[indexPath.row].checkmark  = true
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //crée un bouton delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
            // The UIAlertControllerStyle ActionSheet is used when there are more than one button.
            
            func myHandler(alert: UIAlertAction){
                
                
                self.url = "http://178.62.22.140:8080/api/contact/suppression?idUser=" + String(ConnectionView.idUser) + "&idContactSupprime=" + String(describing: self.cellInfo.remove(at: indexPath[1]).idRecepteur)
                var request = URLRequest(url: URL(string: self.url)!);
                request.httpMethod = "DELETE";
                self.makeRequest(request: request, create: "suppression", row: indexPath.row) //le parametre create permet de déterminer ce que le résultat de la requete sera
                
                self.tableView.reloadData()
                print("You tapped: \(alert.title)")
            }
            
            let otherAlert = UIAlertController(title: "Voulez vous supprimer cet ami?", message: "Cette action est irréversible.", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            
            let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
            
            let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(callFunction)
            otherAlert.addAction(dismiss)
            
            self.present(otherAlert, animated: true, completion: nil)
            
            
            //envoi l'effacement du contact à la BDD
            
            
        }),
                //crée un bouton Desactivate qui supprime la checkMark de la ligne selectionnée
            UITableViewRowAction(style: .normal, title: "Historique", handler: { (action, indexPath) in
            
            //self.cellInfo[indexPath.row].checkmark = false
            //tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            //envoi le blocage du checkMark à la BDD
            
            //self.tableView.reloadData()
                
                func myHandler(alert: UIAlertAction){
                    
                    ConnectionView.Historique = self.cellInfo[indexPath.row].idRecepteur
                    print(self.cellInfo[indexPath.row].idRecepteur)
                    print(ConnectionView.Historique)
                    
                }
                func myHandler2(alert: UIAlertAction){
                    
                    ConnectionView.Historique = -1
                    print(ConnectionView.Historique)
                    
                }
               
                
                if ConnectionView.Historique != self.cellInfo[indexPath.row].idRecepteur {
                    
                    let otherAlert = UIAlertController(title: "Voulez vous afficher l'historique de cet ami?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    
                    
                    let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
                    
                    let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    // relate actions to controllers
                    otherAlert.addAction(callFunction)
                    otherAlert.addAction(dismiss)
                    
                    self.present(otherAlert, animated: true, completion: nil)
                    
                }
                
                
                if ConnectionView.Historique == self.cellInfo[indexPath.row].idRecepteur{
                    
                    let otherAlert = UIAlertController(title: "Voulez vous arreter d'afficher l'historique de cet ami?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    
                    
                    let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler2)
                    
                    let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    // relate actions to controllers
                    otherAlert.addAction(callFunction)
                    otherAlert.addAction(dismiss)
                    
                    self.present(otherAlert, animated: true, completion: nil)
                    
                }
                
                
            })
            
            
            
            
            
            
            
            
            
            
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                
                                self.cellInfo = self.cellInfo + [Contact(login: self.dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idRecepteur"] as! Int)]
                                
                                
                            }else{
                                
                                self.cellInfo = self.cellInfo + [Contact(login: self.dictionary[index]["pseudo"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idDemandeur"] as! Int)]
                                
                                
                            }
                            
                        }
                        
                    }
                }

                
                if create == "suppression"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    
                    
                    //self.cellInfo.remove(at: row)
                    
                    
                    
                }

                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
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
