//
//  OrderViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


class ReservePgViewController: UITableViewController{
    
    
    // Database Reference
    let db = Firestore.firestore()
    
    var reservations = [Reservation]()
    let curUser = ""
    
    // Reservation Fields
    var date: String = ""
    var time: String = ""
    var duration: String = ""
    var tableNumber: String = ""
    var reservationID: Int = 0
    
    override func viewDidLoad() {
        print("Loading the ReservePG Controller")
        super.viewDidLoad()
        getReservations()
    }
    
    // MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reservations.count)
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath)
        cell.textLabel?.text = reservations[indexPath.row].tableNumber
        return cell
    }
    
    // MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        date = reservations[indexPath.row].date
        time = reservations[indexPath.row].time
        duration = reservations[indexPath.row].duration
        tableNumber = reservations[indexPath.row].tableNumber
        reservationID = reservations[indexPath.row].reservationID
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        performSegue(withIdentifier: Constants.Me.reservationPopup, sender: self)
    }
    
    
    func getReservations(){
        reservations = []
        if let curUser = Auth.auth().currentUser?.email{
            db.collection(Constants.FStoreCollection.reservations).getDocuments { snapDocs, error in
                if let e = error{
                    print("Issue retreiving current reservations: \(e)")
                }
                else{
                    if let snapDocs = snapDocs?.documents{
                        for reservation in snapDocs{
                            let user = reservation.data()[Constants.FStoreField.Reservation.user] as! String
                            if  user == curUser { //if input date = current selected reservation date
                                let date = reservation.data()[Constants.FStoreField.Reservation.date] as! String
                                let time = reservation.data()[Constants.FStoreField.Reservation.time] as! String
                                let duration = reservation.data()[Constants.FStoreField.Reservation.duration] as! String
                                let tableNum = reservation.data()[Constants.FStoreField.Reservation.tableNumber] as! String
                                let reservationID = reservation.data()[Constants.FStoreField.Reservation.reservationID] as! Int
                                let createRes = Reservation(user: curUser, date: date, time: time, duration: duration, tableNumber: tableNum, reservationID: reservationID)
                                self.reservations.append(createRes)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                print(self.reservations)
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.reservationsToProfile, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Me.reservationPopup{
            let destinationVC = segue.destination as? ViewReservationViewController
            destinationVC?.date = date
            destinationVC?.time = time
            destinationVC?.duration = duration
            destinationVC?.table = tableNumber
            destinationVC?.bookingId = String(reservationID)
        }
    }
    
    
}
