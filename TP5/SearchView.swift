//
//  SearchView.swift
//  TP5
//
//  Created by m2sar on 10/05/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UITableViewController , UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var FriendTableView: UITableView!
    
    
    var cellInfo = [Contact(login: "Leo",checkmark: false,x: 10.00,y: 20.00),
                    Contact(login: "Benoit", checkmark: true, x: 70.00, y: 80.00),
                    Contact(login: "Pierre",checkmark: true, x: 30.00, y: 40.00),
                    Contact(login: "Romain",checkmark: false, x: 50.00,y: 60.00)]
    var filteredContact = [Contact]()
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //searchBar.delegate = self
        
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
    //func filterContentForSearchText(searchText: String, scope: String = "All") {
        
      //          filteredContact = cellInfo.filter { Contact in
        //    return Contact.login.lowercaseString.(searchText.lowercaseString)
        //}
        
        //tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        
        //appel à la base de donnée qui renvoi ou non des gens, on alimente donc ou non la table view
        
    }
    
    
//}
