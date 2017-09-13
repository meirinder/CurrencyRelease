//
//  HelpTableViewController.swift
//  CurrencyConverter
//
//  Created by Savely on 13.09.17.
//  Copyright © 2017 Savely. All rights reserved.
//

import UIKit
import SwiftyJSON

class HelpTableViewController: UITableViewController {

    @IBOutlet var itemCell: UITableViewCell!

    let allCharCodes = ["RUR","AUD","AZN","GBP","AMD","BYN","BGN","BRL","HUF","HKD","DKK","USD","EUR","INR","KZT","CAD","KGS","CNY","MDL","NOK","PLN","RON","XDR","SGD","TJS","TRY","TMT","UZS","UAH","CZK","SEK","CHF","ZAR","KRW","JPY"]
    var itemStore: [String: Item] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurseOnDay()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func getCurseOnDay(){
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            let json = JSON(data: data)
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            let instanse = Item(charCode: "RUR", id: "R00000", numCode: 643, name: "Российский рубль", value: 1, previous: 1, nominal: 1)
            self.itemStore["RUR"] = instanse
            
            
            for i in 1...json["Valute"].count
            {
                let instanse = Item(charCode: json["Valute"][self.allCharCodes[i]]["CharCode"].string!,
                                    id: json["Valute"][self.allCharCodes[i]]["ID"].string!,
                                    numCode: json["Valute"][self.allCharCodes[i]]["NumCode"].intValue,
                                    name: json["Valute"][self.allCharCodes[i]]["Name"].string!,
                                    value: json["Valute"][self.allCharCodes[i]]["Value"].doubleValue,
                                    previous: json["Valute"][self.allCharCodes[i]]["Previous"].int!,
                                    nominal:json["Valute"][self.allCharCodes[i]]["Nominal"].doubleValue )
                
                self.itemStore[self.allCharCodes[i]] = instanse
            }
        }
        
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
