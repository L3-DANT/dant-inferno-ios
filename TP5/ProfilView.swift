//
//  ProfilView.swift
//  TP5
//
//  Created by m2sar on 04/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation

import UIKit

class ProfilView: UIViewController {
    
 
    @IBOutlet weak var GpsSwitch: UISwitch!
    @IBAction func LogOut(_ sender: AnyObject) {
        
        
        ConnectionView.token = ""
        print("token: \(ConnectionView.token)")
        self.dismiss(animated: true, completion: nil) //sortir du present
        
    }
    
    @IBAction func GpsSwitch(_ sender: AnyObject) {
        
        //envoi la valeur du bouton à la base de donnée
        
    }
}
