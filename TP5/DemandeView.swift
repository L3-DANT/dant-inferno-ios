//
//  DemandeView.swift
//  TP5
//
//  Created by m2sar on 29/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation
import UIKit

class DemandeView: UITableViewController {
    
    
    
    var url: String = ""
    var cellInfoDemande = [Contact]()
    var dictionary = [[String: Any]]()
    
    
    @IBOutlet var DemandeTableView: UITableView!
   
    override func viewDidLoad() {
        
        
        url = "http://178.62.22.140:8080/api/private/contact/liste/demandes?idUser=" + String(ConnectionView.idUser) + "&token=" + ConnectionView.token
        makeRequest(request: URLRequest(url: URL(string: url)!), create: "tabDemande", row: 0) //le parametre create permet de déterminer ce que le résultat de la requete sera
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //searchBar.delegate = self
        
    }
    
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
       
    
    
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfoDemande.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mycell") //my cell is the identifier
        
        cell.textLabel?.text = cellInfoDemande[indexPath.row].login //"Test"
        //        cell.accessoryType = .checkmark
        
        return cell
        
    }
    
    
    //crée un bouton delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
            // The UIAlertControllerStyle ActionSheet is used when there are more than one button.
            
            func myHandler(alert: UIAlertAction){
                

                self.url = "http://178.62.22.140:8080/api/private/contact/refus?idUser=" + String(ConnectionView.idUser) + "&idContactRefuse=" + String(describing: self.cellInfoDemande.remove(at: indexPath[1]).idRecepteur) + "&token=" + ConnectionView.token
                var request = URLRequest(url: URL(string: self.url)!);
                request.httpMethod = "DELETE";
                
                self.makeRequest(request: request, create: "suppression", row: indexPath.row) //le parametre create permet de déterminer ce que le résultat de la requete sera
                
                
                //self.cellInfoDemande.remove(at: indexPath.row)
                //tableView.reloadData()
                print("You tapped: \(alert.title)")
            }
            
            let otherAlert = UIAlertController(title: "Voulez vous supprimer cette demande d'ami?", message: "(Cette action est irréversible.)", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            
            let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
            
            let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(callFunction)
            otherAlert.addAction(dismiss)
            
            self.present(otherAlert, animated: true, completion: nil)
            
            
            
        }),
                //////crée un bouton Desactivate qui supprime la checkMark de la ligne selectionnée
            UITableViewRowAction(style: .normal, title: "Accepter", handler: { (action, indexPath) in
                
                func myHandler(alert: UIAlertAction){
                  

                    self.url = "http://178.62.22.140:8080/api/private/contact/acceptation?idUser=" + String(ConnectionView.idUser)+"&idContactAccepte=" + String(describing: self.cellInfoDemande.remove(at: indexPath[1]).idRecepteur) + "&token=" + ConnectionView.token
                    var request = URLRequest(url: URL(string: self.url)!);
                    request.httpMethod = "POST";
                    
                    self.makeRequest(request: request, create: "suppression", row: indexPath.row) //le parametre create permet de déterminer ce que le résultat de la requete sera
                    
                    
                    //self.cellInfoDemande.remove(at: indexPath.row)
                    //tableView.reloadData()
                    print("You tapped: \(alert.title)")
                    
                    
                }
                
                let otherAlert = UIAlertController(title: "Voulez vous accepter cette demande d'ami?", message: "(Vous pourrez des lors, communiquer et visualiser la position de cette personne !)", preferredStyle: UIAlertControllerStyle.actionSheet)
                
                
                
                let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
                
                let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
                
                // relate actions to controllers
                otherAlert.addAction(callFunction)
                otherAlert.addAction(dismiss)
                
                self.present(otherAlert, animated: true, completion: nil)
                

                
            
            })
        ]
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
                
                if create == "tabDemande"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    self.dictionary = json as! [[String: Any]]//{
                    
                    if self.dictionary.count >= 1{
                        
                        for index in 0...self.dictionary.count - 1 {
                            
                            self.cellInfoDemande = self.cellInfoDemande + [Contact(login: self.dictionary[index]["pseudoDemandeur"] as! String,checkmark: false, idRecepteur: self.dictionary[index]["idDemandeur"] as! Int)]
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
                    }
                    
                }
                
                if create == "suppression"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    
                    
                    //self.cellInfoDemande.remove(at: row)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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




