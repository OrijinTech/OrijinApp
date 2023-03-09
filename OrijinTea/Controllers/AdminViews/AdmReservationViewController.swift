//
//  AdmReservationViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/9/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class AdmReservationViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    // outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickDateBtnOutlet: UIButton!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reservationTable: UITableView!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var clickView: UIView!
    
    
    // Fetched Reservations
    var reservations:[Reservation] = []
    var selectedDate: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickViewTapped))
        pickerViewHeight.constant = 0
        clickView.isHidden = true
        reservationTable.delegate = self
        reservationTable.dataSource = self
        datePickerOutlet.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        reservationTable.addGestureRecognizer(tapGesture)
    }
    
    func hideDatePicker(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.clickView.isHidden = true
                self.pickerViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        else{
            UIView.animate(withDuration: 0.15) {
                self.clickView.isHidden = false
                self.pickerViewHeight.constant = 386
                self.view.layoutIfNeeded()
            }
        }
       
    }
    
    @objc func clickViewTapped(){
        hideDatePicker(true)
    }
    
    func getReservations(for date: String){
        print("Start loading reservations")
        reservations.removeAll()
        let collectionRef = db.collection(Constants.FStoreCollection.reservations)
        collectionRef.getDocuments { querySnapshot, error in
            if let e = error{
                print("Issue retreiving current reservations: \(e)")
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let curDate = doc.data()[Constants.FStoreField.Reservation.date] as! String
                        if date == curDate { //if input date = current selected reservation date
                            let resUser = doc.data()[Constants.FStoreField.Reservation.user] as! String
                            let date = doc.data()[Constants.FStoreField.Reservation.date] as! String
                            let time = doc.data()[Constants.FStoreField.Reservation.time] as! String
                            let duration = doc.data()[Constants.FStoreField.Reservation.duration] as! String
                            let tableNum = doc.data()[Constants.FStoreField.Reservation.tableNumber] as! String
                            let reservationID = doc.data()[Constants.FStoreField.Reservation.reservationID] as! Int
                            let createRes = Reservation(user: resUser, date: date, time: time, duration: duration, tableNumber: tableNum, reservationID: reservationID)
                            self.reservations.append(createRes)
                        }
                    }
                    DispatchQueue.main.async {
                        self.reservationTable.reloadData()
                        print("RESERVATIONS: \(self.reservations)")
                    }
                }
            }
        }
    }
    
    
    func dateToStr(_ date: Date) -> String{
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        return dFormatter.string(from: date)
    }
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        selectedDate = dateToStr(datePicker.date)
        dateLabel.text = selectedDate
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        getReservations(for: selectedDate)
        hideDatePicker(true)
    }
    
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        hideDatePicker(true)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.allResToAdmMain, sender: self)
    }
    
    @IBAction func pickDateBtn(_ sender: UIButton) {
        hideDatePicker(false)
    }
    
}


extension AdmReservationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageResCell", for: indexPath)
        cell.textLabel?.text = "Booking ID: \(reservations[indexPath.row].reservationID)   |   Time: \(reservations[indexPath.row].time)"
        return cell
    }
    
    
}
