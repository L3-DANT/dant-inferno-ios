//
//  ViewConnexion.swift
//  TP5
//
//  Created by m2sar on 02/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation

import UIKit

class ConnectionView: UIViewController ,GIDSignInUIDelegate{
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var TextMail: UITextField!
    @IBOutlet weak var TextMdp: UITextField!
    @IBOutlet weak var GIDSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    @IBAction func connect(_ sender: UIButton) {
        
        if TextMail.text == "leo.rbrt@gmail.com" {
            if TextMdp.text == "123456789"{
                
                let premierTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremierTab")
                
                
                self.present(premierTab, animated: true, completion: nil) //montre sans bouton back
                //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>) sortir du present
                
                //self.navigationController?.pushViewController(mapView, animated: true) //montre avec un bouton back
                //self.popoverPresentationController sortir du push
                
                
            }else{
                
                print("False Mdp")
                
            }
            
            
        }else{
            
            print("False Mail")
            
        }
    }
    
    @IBAction func SignUp(_ sender: AnyObject) {
        
        let signUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpView")
        
        
        //self.present(signUpView, animated: true, completion: nil) //montre sans bouton back
        //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>) // sortir du present
        
        self.navigationController?.pushViewController(signUpView, animated: true) //montre avec un bouton back
        //self.popoverPresentationController // sortir du push
        

    }
    
}
