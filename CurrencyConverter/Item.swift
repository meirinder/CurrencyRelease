//
//  Item.swift
//  CurrencyConverter
//
//  Created by Savely on 12.09.17.
//  Copyright © 2017 Savely. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    let charCode: String
    let id: String
    let numCode: Int
    let name: String
    var value: Double
    var previous: Int
    let nominal: Int

    
    init(charCode: String, id: String, numCode: Int, name: String, value: Double, previous: Int, nominal: Int) {
        self.charCode = charCode
        self.id = id
        self.numCode = numCode
        self.name = name
        self.value = value
        self.previous = previous
        self.nominal = nominal
        
        super.init()
    }
}
