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
    // Me tab
    struct Me{
        static let profileToReservations: String = "profileToReservations"
        static let reservationsToProfile: String = "reservationsToProfile"
        static let reservationPopup: String = "reservationPopup"
        static let hideResPopup: String = "hideResPopup"
        static let meToLogin: String = "meToLogin"
        static let profileToInfo: String = "profileToInfo"
        static let profileInfoToMe: String = "profileInfoToMe"
        static let toTeaBook: String = "toTeaBook"
        static let teaBookToMe: String = "teaBookToMe"
        static let toSpecificProductInMe: String = "toSpecificProductInMe"
    }
    
    struct Shop{
        static let toProducts: String = "toProducts"
        static let toProductOverview: String = "toProductOverview"
        static let generalTypeToTypeProducts: String = "generalTypeToTypeProducts"
        static let typeProductsToGeneralType: String = "typeProductsToGeneralType"
        static let toSpecificProduct: String = "toSpecificProduct"
        static let specificToProductList: String = "specificToProductList"
        static let toMyTeaBook: String = "toMyTeaBook"
    }
    
    struct Admin{
        static let loginToAdmAcc: String = "loginToAdmAcc"
        static let admToAllReservations: String = "admToAllReservations"
        static let allResToAdmMain: String = "allResToAdmMain"
        static let admResDetail: String = "admResDetail"
        static let admMainToTables: String = "admMainToTables"
        static let admTablesToMain: String = "admTablesToMain"
        static let admToSpecificTable: String = "admToSpecificTable"
        static let admBackToTables: String = "admBackToTables"
        
    }
    

// MARK: - View Identifiers
    static let prodTypeCell: String = "prodTypeCell"
    static let admTableCell: String = "admTableCell"
    static let tableCell: String = "tableCell"
    static let searchedCell: String = "searchedCell"
    
    
    
    
    
    
// MARK: - FireStore constants
    
    // Collection
    struct FStoreCollection{
        static let reservations: String = "reservations"
        static let tables: String = "tables"
        static let adminStats: String = "teashopAdminStats"
        static let users: String = "users"
        static let product: String = "product"
        static let notes: String = "notes"
        static let menu: String = "menu"
        static let curItems: String = "curItems"
        static let orderHistory: String = "orderHistory"
    }
    
    // Document
    struct FStoreDocument{
        static let tableBooking = "tableBooking"
        static let statics = "statics"
    }
    
    
    // Fields
    struct FStoreField{
        // tables
        struct Table{
            static let tableNames: String = "name"
            static let tableEmpty: String = "isEmpty"
            static let tableID: String = "tableID"
            static let curItems: String = "curItems"
        }

        // reservations
        struct Reservation{
            static let date: String = "date"
            static let duration: String = "duration"
            static let tableNumber: String = "tableNumber"
            static let time: String = "time"
            static let user: String = "user"
            static let reservationID: String = "reservationID"
        }
        
        struct AdminFields{
            static let tableBookingId = "id"
        }
        
        struct Users{
            static let id: String = "id"
            static let firstName: String = "firstName"
            static let lastName: String = "lastName"
            static let email: String = "email"
            static let teaPoints: String = "teaPoints"
            static let userName: String = "userName"
            static let favoriteProducts: String = "favoriteProducts"
            static let note: String = "note"
            static let userType: String = "userType"
        }
        
        struct Menu{
            static let name: String = "name"
            static let price: String = "price"
            static let amount: String = "amount(g)"
            static let tag: String = "tag"
        }
        
        struct Statics{
            static let orderID: String = "orderID"
        }
        

    }

    struct TextCont{
        static let orijinAddress: String = "Charvatova 1988/3"
    }
    
    
}
