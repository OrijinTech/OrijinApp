//
//  Product.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/28/23.
//

import Foundation

class Product: Codable{
    @objc var productName: String?
    @objc var categoryPic: String?
    @objc var categoryName: String? //茶类
    @objc var productionPlace: String?
    @objc var productionYear: String?
    @objc var description: String?
    @objc var productTag: String?
    
    init(productName: String? = nil, categoryPic: String? = "Tea Icon", categoryName: String? = nil, productionPlace: String? = nil, productionYear: String? = nil, description: String? = nil, productTag: String? = nil) {
        self.productName = productName
        self.categoryPic = categoryPic
        self.categoryName = categoryName
        self.productionPlace = productionPlace
        self.productionYear = productionYear
        self.description = description
    }
    
    
}
