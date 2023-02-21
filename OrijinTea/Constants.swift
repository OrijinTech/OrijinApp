//
//  Constants.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/7/23.
//

import Foundation

class Constants{
    
// MARK: - Segue names
    static let loginToSign: String = "loginToSign"
    static let signToLogin: String = "signToLogin"
    static let signToMain: String = "signToMain"
    static let loginToMain: String = "loginToMain"
    static let mainToShop: String = "mainToShop"
    static let mainToBook: String = "mainToBook"
    static let shopToMain: String = "shopToMain"
    static let visitToMain: String = "visitToMain"
    static let bookToBookTable: String = "bookToBookTable"
    static let bookTableToVisit: String = "bookTableToVisit"

// MARK: - View Identifiers
    static let prodTypeCell: String = "prodTypeCell"
    
// MARK: - FireStore constants
    struct FStore{
        static let reservations: String = "reservations"
        static let users: String = "users"
        static let tables: String = "tables"
    }

    
    
    
}
