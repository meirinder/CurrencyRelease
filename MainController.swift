//
//  MainView.swift
//  ConvertCurrency
//
//  Created by Savely on 12.09.17.
//  Copyright © 2017 Savely. All rights reserved.
//

import UIKit
import SwiftyJSON


class MainView: UIViewController {

    @IBOutlet var fromTextFieldForValute: UITextField!
    @IBOutlet var toTextFieldForValute: UITextField!
    @IBOutlet var leftTextField: UITextField!
    @IBOutlet var rightTextField: UITextField!
    
    let allCharCodes = ["RUB","AUD","AZN","GBP","AMD","BYN","BGN","BRL","HUF","HKD","DKK","USD","EUR","INR","KZT","CAD","KGS","CNY","MDL","NOK","PLN","RON","XDR","SGD","TJS","TRY","TMT","UZS","UAH","CZK","SEK","CHF","ZAR","KRW","JPY"]
    var itemStore: [String: Item] = [:]
    
    func testr(){
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            let json = JSON(data: data)
           
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            let instanse = Item(charCode: "RUB", id: "R00000", numCode: 643, name: "Российский рубль", value: 1, previous: 1, nominal: 1)
            self.itemStore["RUB"] = instanse

            
            for i in 1...json["Valute"].count
            {
                let instanse = Item(charCode: json["Valute"][self.allCharCodes[i]]["CharCode"].string!,
                               id: json["Valute"][self.allCharCodes[i]]["ID"].string!,
                               numCode: json["Valute"][self.allCharCodes[i]]["NumCode"].intValue,
                               name: json["Valute"][self.allCharCodes[i]]["Name"].string!,
                               value: json["Valute"][self.allCharCodes[i]]["Value"].doubleValue,
                               previous: json["Valute"][self.allCharCodes[i]]["Previous"].int!,
                               nominal:json["Valute"][self.allCharCodes[i]]["Nominal"].int! )
                
                self.itemStore[self.allCharCodes[i]] = instanse
            }
        }
        
        task.resume()
    }
    
    
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        fromTextFieldForValute.resignFirstResponder()
        toTextFieldForValute.resignFirstResponder()
        leftTextField.resignFirstResponder()
        rightTextField.resignFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        testr()
        // Do any additional setup after loading the view.
    }
    
    
   

}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
