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
        
    }
    

// MARK: - View Identifiers
    static let prodTypeCell: String = "prodTypeCell"
    
// MARK: - FireStore constants
    
    // Collection
    struct FStoreCollection{
        static let reservations: String = "reservations"
        static let tables: String = "tables"
        static let adminStats: String = "teashopAdminStats"
        static let users: String = "users"
    }
    
    // Document
    struct FStoreDocument{
        static let tableBooking = "tableBooking"
    }
    
    
    // Fields
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
        }
        

    }

    struct TextCont{
        static let orijinAddress: String = "Charvatova 1988/3"
    }
    
    
}
