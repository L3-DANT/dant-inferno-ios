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
    

    
    var cellInfo = [Contact(login: "Leo",checkmark: false,x: 10.00,y: 20.00),
                    Contact(login: "Benoit", checkmark: true, x: 70.00, y: 80.00),
                    Contact(login: "Pierre",checkmark: true, x: 30.00, y: 40.00),
                    Contact(login: "Romain",checkmark: false, x: 50.00,y: 60.00)]
    
    
    @IBOutlet weak var rechercheButton: UIBarButtonItem!
    
    
    @IBOutlet weak var UrlButton: UIButton!
    
    @IBAction func url(_ sender: AnyObject) {
        
        print("--------------------Début-------------------------------")
        var result = AppelHttp(urldonne: "https://jsonplaceholder.typicode.com/posts")
        print("--------------------Fin---------------------------------")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        cell.textLabel?.text = cellInfo[indexPath.row].login //"Test"
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
        
        //envoi l'activation/desactivation du checkMark à la BDD
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //crée un bouton delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
            // The UIAlertControllerStyle ActionSheet is used when there are more than one button.
            
            func myHandler(alert: UIAlertAction){
                self.cellInfo.remove(at: indexPath.row)
                tableView.reloadData()
                print("You tapped: \(alert.title)")
            }
            
            let otherAlert = UIAlertController(title: "Voulez vous VRAIMENT détruire cet ami?", message: "Une fois détruit, la seul façon de le ressucité sera de lui re-envoyer une demande #Relou.", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            
            let callFunction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.destructive, handler: myHandler)
            
            let dismiss = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel, handler: nil)
            
            // relate actions to controllers
            otherAlert.addAction(callFunction)
            otherAlert.addAction(dismiss)
            
            self.present(otherAlert, animated: true, completion: nil)
            
            
            //envoi l'effacement du contact à la BDD
            
            
        }),
                //crée un bouton Desactivate qui supprime la checkMark de la ligne selectionnée
            //UITableViewRowAction(style: .normal, title: "Desactivate", handler: { (action, indexPath) in
            
            //self.cellInfo[indexPath.row].checkmark = false
            //tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            //envoi le blocage du checkMark à la BDD
            
            //tableView.reloadData()
            //})
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
