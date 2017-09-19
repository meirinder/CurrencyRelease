
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
    @IBOutlet var errorLabel: UILabel!
    
    
    let allCharCodes = ["RUR","AUD","AZN","GBP","AMD","BYN","BGN","BRL","HUF","HKD","DKK","USD","EUR","INR","KZT","CAD","KGS","CNY","MDL","NOK","PLN","RON","XDR","SGD","TJS","TRY","TMT","UZS","UAH","CZK","SEK","CHF","ZAR","KRW","JPY"]
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
    
    func convertCurrency(fromTextField: UITextField!, fromValute: String?, toTextField: UITextField!, toValute: String?)
    {
        if (leftLabel.text != nil)&&(rightLabel.text != nil)
        {
            if ((leftLabel.text?.isEmpty)!)||((rightLabel.text?.isEmpty)!)
            {
                errorLabel.text = "Ошибка ввода валюты"
            }
            else
            {
                errorLabel.text = ""
                var converted = Double(fromTextField.text!)
                converted = converted! * (self.itemStore[fromValute!]?.value)!
                converted = converted! / (self.itemStore[fromValute!]?.nominal)!
                converted = converted! * (self.itemStore[toValute!]?.nominal)!
                converted = converted! / (self.itemStore[toValute!]?.value)!
                
                toTextField.text = "\(converted!)"
            }
        }
        else
        {
            errorLabel.text = "Ошибка ввода валюты"
        }
        
        
    }
    @IBAction func cleanAllTextFields(_ sender: Any) {
        cleanTextFields(textFields: fromTextFieldForValute,toTextFieldForValute,leftTextField,rightTextField)
    }
    
    
    
    
    @IBAction func editingChangedLeft(_ sender: Any) {
        if (leftTextField.text?.isEmpty)!
        {
            rightTextField.text = ""
        }
        else
        {
            if (rightTextField.text == ".") || (leftTextField.text == ".")
            {
                errorLabel.text = "Ошибка ввода значения"
                return
            }
            if (leftTextField.text?.hasSuffix(".."))!
            {
                leftTextField.text = ""
                return
            }
            convertCurrency(fromTextField: leftTextField, fromValute: fromTextFieldForValute.text?.uppercased(), toTextField: rightTextField, toValute: toTextFieldForValute.text?.uppercased())
        }
        
    }
    @IBAction func editingChangedRight(_ sender: Any) {
        if (rightTextField.text?.isEmpty)!
        {
            leftTextField.text = ""
        }
        else
        {
            if (rightTextField.text == ".") || (leftTextField.text == ".")
            {
                errorLabel.text = "Ошибка ввода значения"
                
                return
            }
            if (rightTextField.text?.hasSuffix(".."))!
            {
                rightTextField.text = ""
                return
            }
            convertCurrency(fromTextField: rightTextField, fromValute: toTextFieldForValute.text?.uppercased() , toTextField: leftTextField, toValute: fromTextFieldForValute.text?.uppercased())
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
        fromTextFieldForValute.resignFirstResponder()
        toTextFieldForValute.resignFirstResponder()
        leftTextField.resignFirstResponder()
        rightTextField.resignFirstResponder()
        
    }
    @IBAction func FromTextFieldEditingDidEnd(_ sender: Any) {
        leftLabel.text = self.itemStore[fromTextFieldForValute.text!.uppercased()]?.name
    }
    @IBAction func ToTextFieldEditingDidEnd(_ sender: Any) {
        rightLabel.text = self.itemStore[toTextFieldForValute.text!.uppercased()]?.name
    }
    @IBAction func fromAndToTextFieldEditingDidBegin(_ sender: Any) {
        cleanTextFields(textFields: leftTextField,rightTextField)
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
        leftLabel.text = ""
        rightLabel.text = ""
        errorLabel.text = ""
        
        
        getCurseOnDay()
    }
    

   

}
    

