//
//  Product.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/28/23.
//

import Foundation

class Product: Codable{
    @objc var productName: String?
    @objc var productPic: String?
    @objc var categoryName: String? //茶类
    @objc var productionPlace: String?
    @objc var productionYear: String?
    @objc var description: String?
    @objc var productTag: String?
    @objc var productClass: String?
    @objc var unit: String?
    var price: Int?
    
    init(productName: String? = nil, productPic: String? = "Tea Icon", categoryName: String? = nil, productionPlace: String? = nil, productionYear: String? = nil, description: String? = nil, productTag: String? = nil, productClass: String? = nil, unit: String? = nil, price: Int? = nil) {
        self.productName = productName
        self.productPic = productPic
        self.categoryName = categoryName
        self.productionPlace = productionPlace
        self.productionYear = productionYear
        self.description = description
        self.productTag = productTag
        self.productClass = productClass
        self.unit = unit
        self.price = price
    }
    
    
}
