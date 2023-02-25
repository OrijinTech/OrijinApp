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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReservations()
    }
    
    // MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        performSegue(withIdentifier: Constants.Me.reservationPopup, sender: self)
    }
    
    
    func getReservations(){
        reservations = []
        if let curUser = Auth.auth().currentUser?.email{
            let docID = curUser
            db.collection(Constants.FStoreCollection.reservations).document(docID).getDocument { querySnapshot, error in
                if let e = error{
                    print("Issue retreiving current free tables: \(e)")
                }
                else{
                    if let doc = querySnapshot, doc.exists{
                        let date = doc.data()?[Constants.FStoreField.Reservation.date] as? String
                        let time = doc.data()?[Constants.FStoreField.Reservation.time] as? String
                        let duration = doc.data()?[Constants.FStoreField.Reservation.duration] as? String
                        let tableNum = doc.data()?[Constants.FStoreField.Reservation.tableNumber] as? String
                        // create reservation
                        let createRes = Reservation(user: curUser, date: date!, time: time!, duration: duration!, tableNumber: tableNum!)
                        self.reservations.append(createRes)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
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
            
        }
    }
    
    
}
