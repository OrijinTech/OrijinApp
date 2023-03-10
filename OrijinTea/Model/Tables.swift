//
//  Tables.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/10/23.
//

import Foundation

class Tables: Codable{
    var isEmpty: Bool
    var name: String
    var numPeople: Int
    var tableID: String
    var currentProducts: [Product]?
    
    init(isEmpty: Bool, name: String, numPeople: Int, tableID: String, currentProducts: [Product]? = nil) {
        self.isEmpty = isEmpty
        self.name = name
        self.numPeople = numPeople
        self.tableID = tableID
        self.currentProducts = currentProducts
    }
    
}
