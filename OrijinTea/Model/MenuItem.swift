//
//  MenuItem.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/10/23.
//

import Foundation

class MenuItem: Codable{
    let amount: Int
    let name: String
    let price: Int
    let tag: String
    var itemCount: Int

    init(amount: Int, itemCount: Int = 1, name: String, price: Int, tag: String) {
        self.amount = amount
        self.itemCount = itemCount
        self.name = name
        self.price = price
        self.tag = tag
        
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "amount": self.amount,
            "name": self.name,
            "price": self.price,
            "tag": self.tag,
            "itemCount": self.itemCount
        ]
    }
    
//    func incrementItemNum(){
//        self.itemCount! += 1
//    }
//
//    func decrementItemNum(){
//        self.itemCount! -= 1
//    }
    

    
}
