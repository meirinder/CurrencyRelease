//
//  HelpTableViewController.swift
//  CurrencyConverter
//
//  Created by Savely on 13.09.17.
//  Copyright © 2017 Savely. All rights reserved.
//

import UIKit
//import SwiftyJSON

class HelpTableViewController: UITableViewController {

    
    
    var allCharCodes: [String] = []
    var itemStore: [String: Item] = [:]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 35
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell", for: indexPath) as! HelpTableViewCell
        
        
        
        if itemStore[allCharCodes[indexPath.row]] != nil
        {
            cell.lableName.text = "\(itemStore[allCharCodes[indexPath.row]]!.name)"
            cell.lableCharCode.text = "\(itemStore[allCharCodes[indexPath.row]]!.charCode)"

        }

       
        return cell
    }
 

}
