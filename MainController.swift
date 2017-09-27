
//  MainView.swift
//  ConvertCurrency
//
//  Created by Savely on 12.09.17.
//  Copyright © 2017 Savely. All rights reserved.
//

import UIKit
import SwiftyJSON



class MainView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var leftPickerView: UIPickerView!
    @IBOutlet var leftTextField: UITextField!
    @IBOutlet var rightTextField: UITextField!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!

    var fromText: String = ""
    var toText: String = ""
    
    let allCharCodes = ["RUR","AUD","AZN","GBP","AMD",
                        "BYN","BGN","BRL","HUF","HKD","DKK","USD",
                        "EUR","INR","KZT","CAD","KGS","CNY",
                        "MDL","NOK","PLN","RON","XDR","SGD",
                        "TJS","TRY","TMT","UZS","UAH","CZK","SEK","CHF","ZAR","KRW","JPY"]
    var itemStore: [String: Item] = [:]
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCharCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCharCodes[row]
    }
    

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cleanTextFields(textFields: leftTextField, rightTextField)
        switch component {
        case 0:
            leftLabel.text = self.itemStore[allCharCodes[row].uppercased()]?.name
            fromText = allCharCodes[row]
        default:
            rightLabel.text = self.itemStore[allCharCodes[row].uppercased()]?.name
            toText = allCharCodes[row]
        }
        print(fromText, toText)
        leftPickerView.selectedRow(inComponent: 0)

        
    }
    func convertCurrency(fromTextField: UITextField!, fromValute: String?, toTextField: UITextField!, toValute: String?)
    {
        var converted = Double(fromTextField.text!)
        converted = converted! * (self.itemStore[fromValute!]?.value)!
        converted = converted! / (self.itemStore[fromValute!]?.nominal)!
        converted = converted! * (self.itemStore[toValute!]?.nominal)!
        converted = converted! / (self.itemStore[toValute!]?.value)!
        
        toTextField.text = "\(converted!)"
    }
    
    
    
    @IBAction func editingChangedLeft(_ sender: Any) {
        if (leftTextField.text?.isEmpty)!
        {
            rightTextField.text = ""
        }
        else
        {
            if (leftTextField.text?.hasSuffix(".."))!
            {
                leftTextField.text = ""
                return
            }
            convertCurrency(fromTextField: leftTextField, fromValute: fromText, toTextField: rightTextField, toValute: toText)
        }
        
    }
    @IBAction func editingChangedRight(_ sender: Any) {
        if (rightTextField.text?.isEmpty)!
        {
            leftTextField.text = ""
        }
        else
        {
            if (rightTextField.text?.hasSuffix(".."))!
            {
                rightTextField.text = ""
                return
            }
            convertCurrency(fromTextField: rightTextField, fromValute: toText, toTextField: leftTextField, toValute: fromText)
        }
        
    }
    
    func cleanTextFields(textFields: UITextField...){
        for textField in textFields
        {
            textField.text = ""
        }
    }
    
       
   @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer)
    {
        leftTextField.resignFirstResponder()
        rightTextField.resignFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HelpTable" {
            let infoTabVC = segue.destination as? HelpTableViewController
            infoTabVC?.itemStore = itemStore
            infoTabVC?.allCharCodes = allCharCodes
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftLabel.text = "Российский рубль"
        rightLabel.text = "Российский рубль"
        
        leftPickerView.delegate = self
        leftPickerView.dataSource = self
        
        getCurseOnDay()
    }
    

   

}
    

