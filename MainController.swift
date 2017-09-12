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
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    
    
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
                               nominal:json["Valute"][self.allCharCodes[i]]["Nominal"].doubleValue )
                
                self.itemStore[self.allCharCodes[i]] = instanse
            }
        }
        
        task.resume()
    }
    
    func convertCurrency(fromTextField: UITextField!, fromValute: String, toTextField: UITextField!, toValute: String, quantity: Double)
    {
        var converted = Double(fromTextField.text!)
        converted = converted! * (self.itemStore[fromValute]?.value)!
        converted = converted! / (self.itemStore[fromValute]?.nominal)!
        
        converted = converted! * (self.itemStore[toValute]?.nominal)!
        converted = converted! / (self.itemStore[toValute]?.value)!
        let res = converted! * quantity
        
        toTextField.text = "\(res)"
        
        
    }
    
    @IBAction func editingChangedLeft(_ sender: Any) {
        convertCurrency(fromTextField: leftTextField, fromValute: fromTextFieldForValute.text! , toTextField: rightTextField, toValute: toTextFieldForValute.text!, quantity: Double(leftTextField.text!)!)
    }
    @IBAction func editingChangedRight(_ sender: Any) {
        convertCurrency(fromTextField: rightTextField, fromValute: toTextFieldForValute.text! , toTextField: leftTextField, toValute: fromTextFieldForValute.text! , quantity: Double(rightTextField.text!)!)
    }
    
    
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        fromTextFieldForValute.resignFirstResponder()
        toTextFieldForValute.resignFirstResponder()
        leftTextField.resignFirstResponder()
        rightTextField.resignFirstResponder()
        
    }
    @IBAction func FromTextFieldEditingDidEnd(_ sender: Any) {
        leftLabel.text = self.itemStore[fromTextFieldForValute.text!]?.name
    }
    @IBAction func ToTextFieldEditingDidEnd(_ sender: Any) {
        rightLabel.text = self.itemStore[toTextFieldForValute.text!]?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftLabel.text = ""
        rightLabel.text = ""
        
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
    
