//
//  Order.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/13/23.
//

import Foundation


class Order: Codable{
    let items: [MenuItem]
    let payTime: String
    let orderID: Int
    let payDay: String

    init(items: [MenuItem], payDay: String, payTime: String, orderID: Int) {
        self.items = items
        self.payTime = payTime
        self.orderID = orderID
        self.payDay = payDay
        
    }
    
    
}
