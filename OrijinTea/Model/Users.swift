//
//  Users.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import Foundation

struct Users: Identifiable, Encodable{
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var teaPoints: Int
    var userName: String
    
    init(id: String, firstName: String, lastName: String, email: String, teaPoints: Int = 0, userName: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.teaPoints = teaPoints
        self.userName = userName
    }
    
    
}
