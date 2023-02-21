//
//  Reservation.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/21/23.
//

import Foundation


class Reservation: Encodable{
    var user: String = ""
    var date: String = ""
    var time: String = ""
    var duration: String = ""
    var numPeople: String = ""
    
    // constructor
    init(user: String, date: String, time: String, duration: String, numPeople: String) {
        self.user = user
        self.date = date
        self.time = time
        self.duration = duration
        self.numPeople = numPeople
    }
    
}
