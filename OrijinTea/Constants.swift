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
    static let bookTableToComfirm: String = "bookTableToComfirm"
    static let confirmationToMain: String = "confirmationToMain"

// MARK: - View Identifiers
    static let prodTypeCell: String = "prodTypeCell"
    
// MARK: - FireStore constants
    struct FStoreCollection{
        static let reservations: String = "reservations"
        static let tables: String = "tables"
    }
    
    struct FStoreField{
        // tables
        struct Table{
            static let tableNames: String = "name"
            static let tableEmpty: String = "isEmpty"
            static let tableID: String = "tableID"
        }

        // reservations
        struct Reservation{
            static let date: String = "date"
            static let duration: String = "duration"
            static let tableNumber: String = "tableNumber"
            static let time: String = "time"
            static let user: String = "user"
        }

    }

    
    
    
}
