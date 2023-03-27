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
    var hideFlag = true
    
    // outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickDateBtnOutlet: UIButton!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reservationTable: UITableView!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // Fetched Reservations
    var reservations:[Reservation] = []
    var selectedDate: String = ""
    var selectedReservation: Reservation?
    
    // Fetcehd Payments
    var payments:[Order] = []
    var selectedPayment: Order?
    
    
    // Incomming Segue
    var mode = "unknown"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewHeight.constant = 0
        reservationTable.delegate = self
        reservationTable.dataSource = self
        searchBar.delegate = self
        datePickerOutlet.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        prepareView(mode)
    }
    
    func prepareView(_ mode: String){
        if mode == "paymentHistory"{
            titleLabel.text = "Past Payments"
            searchBar.isHidden = false
            hideButton.isHidden = true
        }
        else{
            titleLabel.text = "All Reservations"
            searchBar.isHidden = true
            hideButton.isHidden = false
        }
    }
    
    func hideDatePicker(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.pickerViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        else{
            UIView.animate(withDuration: 0.15) {
                self.pickerViewHeight.constant = 386
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func getReservations(for date: String, loadAll all: Bool){
        reservations.removeAll()
        let collectionRef = db.collection(Constants.FStoreCollection.reservations)
        collectionRef.getDocuments { querySnapshot, error in
            if let e = error{
                print("Issue retreiving current reservations: \(e)")
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let resUser = doc.data()[Constants.FStoreField.Reservation.user] as! String
                        let resDate = doc.data()[Constants.FStoreField.Reservation.date] as! String
                        let time = doc.data()[Constants.FStoreField.Reservation.time] as! String
                        let duration = doc.data()[Constants.FStoreField.Reservation.duration] as! String
                        let tableNum = doc.data()[Constants.FStoreField.Reservation.tableNumber] as! String
                        let reservationID = doc.data()[Constants.FStoreField.Reservation.reservationID] as! Int
                        let completed = doc.data()[Constants.FStoreField.Reservation.completed] as! Bool
                        let createRes = Reservation(user: resUser, date: resDate, time: time, duration: duration, tableNumber: tableNum, reservationID: reservationID, completed: completed)
                        if all{
                            self.reservations.append(createRes)
                        }
                        else if date == resDate{
                            self.reservations.append(createRes)
                        }
                    }
                    DispatchQueue.main.async {
                        self.reservationTable.reloadData()
                    }
                }
            }
        }
    }
    
    
    func getPayments(for date: String, loadAll all: Bool){
        payments.removeAll()
        let collectionRef = db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.statics).collection(Constants.FStoreCollection.orderHistory)
        collectionRef.getDocuments { querySnapshot, error in
            if let e = error{
                print("Issue retreiving current payments: \(e)")
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        doc.reference.getDocument { snapDoc, error in
                            if let e = error{
                                print("Error loading table data \(e)")
                            }
                            else{
                                if let doc = snapDoc, doc.exists {
                                    let orderData = doc.data()
                                    let orderID = orderData![Constants.FStoreField.Order.orderID] as! Int
                                    let payTime = orderData![Constants.FStoreField.Order.payTime] as! String
                                    let payDay = orderData![Constants.FStoreField.Order.payDay] as! String
                                    let dictionary = orderData![Constants.FStoreField.Order.items] as! [[String: Any]]
                                    var menuItems = [MenuItem]()
                                    if dictionary.count > 0{
                                        for items in dictionary{
                                            let menuItem = MenuItem(amount: items["amount"] as? Int ?? 1,
                                                                    itemCount: items["itemCount"] as? Int ?? 1,
                                                                    name: items["name"] as! String,
                                                                    price: items["price"] as? Int ?? 0,
                                                                    tag: items["tag"] as! String)
                                            menuItems.append(menuItem) // append all items to menu list
                                        }
                                    }
                                    // Create the order
                                    let order = Order(items: menuItems, payDay: payDay, payTime: payTime, orderID: orderID)
                                    let curDate = payDay // Check for mode
                                    if all{
                                        self.payments.append(order)
                                    }
                                    else{
                                        if date == curDate{
                                            self.payments.append(order)
                                        }
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.reservationTable.reloadData()
                                    }
                                }
                                else {
                                    print("Document does not exist")
                                }
                            }
                        }
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
        if mode == "paymentHistory"{
            getPayments(for: selectedDate, loadAll: false)
        }
        else{
            getReservations(for: selectedDate, loadAll: false)
        }
        hideDatePicker(true)
    }
    
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        hideDatePicker(true)
        dateLabel.text = "No Date Selected"
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.allResToAdmMain, sender: self)
    }
    
    @IBAction func pickDateBtn(_ sender: UIButton) {
        hideDatePicker(false)
        dateLabel.text = dateToStr(Date())
    }
    
    @IBAction func loadAllBtn(_ sender: UIButton) {
        if mode == "paymentHistory"{
            getPayments(for: selectedDate, loadAll: true)
        }
        else{
            getReservations(for: selectedDate, loadAll: true)
        }
        
    }
    
    @IBAction func hideCompletedBtn(_ sender: UIButton) {
        var tempList = [Reservation]()
        if hideFlag{
            for reservation in reservations {
                if !reservation.completed{
                    tempList.append(reservation)
                }
            }
            hideButton.setTitle("Show Completed", for: .normal)
            hideFlag = false
        }
        else{
            getReservations(for: selectedDate, loadAll: true)
            hideButton.setTitle("Hide Completed", for: .normal)
            hideFlag = true
        }
        reservations = tempList
        DispatchQueue.main.async {
            self.reservationTable.reloadData()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Admin.admResDetail{
            let destinationVC = segue.destination as? ViewReservationViewController
            destinationVC?.date = self.selectedReservation!.date
            destinationVC?.time = self.selectedReservation!.time
            destinationVC?.duration = self.selectedReservation!.duration
            destinationVC?.table = self.selectedReservation!.tableNumber
            destinationVC?.bookingId = String(self.selectedReservation!.reservationID)
        }
        else if segue.identifier == Constants.Admin.viewPayment{
            let destinationVC = segue.destination as? ViewOrderViewController
            destinationVC?.chosenOrder = selectedPayment
        }
    }
    
}


extension AdmReservationViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == "paymentHistory"{
            return payments.count
        }
        else{
            return reservations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageResCell", for: indexPath)
        let detailLabel = UILabel()
        var textToCell = ""
        if mode == "paymentHistory"{
            detailLabel.text = "Time: \(payments[indexPath.row].payTime)"
            textToCell = "Order ID: \(payments[indexPath.row].orderID)"
        }
        else{
            if reservations[indexPath.row].completed{
                detailLabel.text = "Completed"
            }
            else{
                detailLabel.text = "Time: \(reservations[indexPath.row].time)"
            }
            textToCell = "Booking ID: \(reservations[indexPath.row].reservationID)"
        }
        detailLabel.sizeToFit()
        cell.accessoryView = detailLabel
        cell.textLabel?.text = textToCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == "paymentHistory"{
            selectedPayment = payments[indexPath.row]
            performSegue(withIdentifier: Constants.Admin.viewPayment, sender: self)
        }
        else{
            selectedReservation = reservations[indexPath.row]
            performSegue(withIdentifier: Constants.Admin.admResDetail, sender: self)
        }
    }
    
    
    
}
