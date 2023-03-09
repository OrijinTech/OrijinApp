//
//  Users.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Users: Identifiable, Codable{
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var teaPoints: Int
    var userName: String
    var favoriteProducts: [DocumentReference]?
    var userType: String
    
    init(id: String, firstName: String, lastName: String, email: String, teaPoints: Int = 0, userName: String = "", favoriteProducts: [DocumentReference] = [], userType: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.teaPoints = teaPoints
        self.userName = userName
        self.favoriteProducts = favoriteProducts
        self.userType = userType
    }
    
    
}
