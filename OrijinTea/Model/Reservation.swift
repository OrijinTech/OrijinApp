//
//  Reservation.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/21/23.
//

import Foundation


class Reservation: Codable{
    var user: String = ""
    var date: String = ""
    var time: String = ""
    var duration: String = ""
    var tableNumber: String = ""
    var reservationID: Int = 0
    var completed: Bool
    
    // constructor
    init(user: String, date: String, time: String, duration: String, tableNumber: String, reservationID: Int, completed: Bool = false) {
        self.user = user
        self.date = date
        self.time = time
        self.duration = duration
        self.tableNumber = tableNumber
        self.reservationID = reservationID
        self.completed = completed
    }
    
    func setCompleted(){
        self.completed = true
    }
    
}
