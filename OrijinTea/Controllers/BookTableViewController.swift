//
//  BookTableViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/13/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class BookTableViewController: UIViewController{
    
    // Database Reference
    let db = Firestore.firestore()

    
    // Constraints Outlets
    @IBOutlet weak var stackDist: NSLayoutConstraint!
    @IBOutlet weak var bookTableDist: NSLayoutConstraint!
    
    // Textfield Outlets
    @IBOutlet weak var tableTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    @IBOutlet weak var errorTxt: UITextField!
    
    // Picker View Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tablePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var durationPicker: UIPickerView!
    
    // View Outlets
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var pickViewHeight: NSLayoutConstraint!

    
    var freeTables = [String]()
    let durations = ["1", "2", "3", "4", "5"]
    var curId = 0
    let tableID = 1
    let dateId = 2
    let timeId = 3
    let durationId = 4
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegates
        loadTables()
        tableTxt.delegate = self
        dateTxt.delegate = self
        timeTxt.delegate = self
        durationTxt.delegate = self
        tablePicker.delegate = self
        durationPicker.delegate = self
        // datasources
        tablePicker.dataSource = self
        durationPicker.dataSource = self
        // setting colors
        datePicker.setValue(UIColor.init(red: 149, green: 145, blue: 85, alpha: 1), forKey: "backgroundColor")
        timePicker.setValue(UIColor.lightGray, forKey: "backgroundColor")
        // tag distribution
        tableTxt.tag = 1
        dateTxt.tag = 2
        timeTxt.tag = 3
        durationTxt.tag = 4
        // pickerView tags
        tablePicker.tag = 1
        durationPicker.tag = 2
        // initial graphic states
        performTransform(true)
        // add listeners
        datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(onTimeValueChanged(_:)), for: .valueChanged)
        // load currently free tables
        
    }
    
    // hiding the pick view and transforming the book table btn
    func performTransform(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.bookTableDist.constant = 0
                //self.pickView.isHidden = true
                self.pickViewHeight.constant = 0
                self.stackDist.constant = 100
                self.view.layoutIfNeeded()
            }
            
        }
        else{ //pick view expanded
            UIView.animate(withDuration: 0.15) {
                self.bookTableDist.constant = 234
                //self.pickView.isHidden = false
                self.pickViewHeight.constant = 260
                self.stackDist.constant = 30
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTxt.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func onTimeValueChanged(_ timePicker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeTxt.text = timeFormatter.string(from: timePicker.date)
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.bookTableToVisit, sender: self)
    }
    
    // user pressed the "Book a Table Button"
    @IBAction func bookTableBtn(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email{
            if isFilled(){ // if all required fields are filled
                // Add booking information for the user to Firestore
                let reservation = Reservation(user: messageSender, date: dateTxt.text!, time: timeTxt.text!, duration: durationTxt.text!, tableNumber: tableTxt.text!)
                do{
                    try db.collection(Constants.FStoreCollection.reservations).document(messageSender).setData(from:reservation)
                    // update the table occupancy
                    var tbID = getTableID(tableTxt.text!)
                    updateTableAvailability(tbID)
                    // go to confirmation pg
                    performSegue(withIdentifier: Constants.bookTableToComfirm, sender: self)
                }
                catch let error{
                    print("Error writing city to Firestore: \(error)")
                }
            }
            else{
                errorTxt.textColor = UIColor.red
                errorTxt.text = "Please fill in all fields!"
            }
        }
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        hideAllPicker()
        performTransform(true)
    }
    
    func hideAllPicker(){
        datePicker.isHidden = true
        timePicker.isHidden = true
        tablePicker.isHidden = true
        durationPicker.isHidden = true
    }
    
    func isFilled() -> Bool{
        if timeTxt.text == "" || dateTxt.text == "" || durationTxt.text == "" || tableTxt.text == ""{
            return false
        }
        else{
            return true
        }
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        switch curId{
        case 1:
            let row = tablePicker.selectedRow(inComponent: 0)
            tablePicker.selectRow(row, inComponent: 0, animated: false)
            tableTxt.text = freeTables[row]
            tableTxt.resignFirstResponder()
            performTransform(true)
        case 2:
            dateTxt.resignFirstResponder()
            performTransform(true)
        case 3:
            timeTxt.resignFirstResponder()
            performTransform(true)
        case 4:
            let row = durationPicker.selectedRow(inComponent: 0)
            durationPicker.selectRow(row, inComponent: 0, animated: false)
            durationTxt.text = durations[row]
            durationTxt.resignFirstResponder()
            performTransform(true)
        default:
            print("error done")
        }

    }
    
    func loadTables(){
        freeTables = []
        db.collection(Constants.FStoreCollection.tables).getDocuments { querySnapshot, error in
            if let e = error{
                print("Issue retreiving current free tables: \(e)")
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let freeTable = doc.data()[Constants.FStoreField.Table.tableEmpty] as! Bool
                        if freeTable{
                            self.freeTables.append(doc.data()[Constants.FStoreField.Table.tableNames] as! String)
                        }
                    }
                }
            }
        }
    }
    
    func getTableID(_ tableN:String) -> String{
        var tableID = ""
        db.collection(Constants.FStoreCollection.tables).getDocuments { (querySnapshot, error) in
            if let e = error{
                print("Issue retreiving current free tables: \(e)")
                return
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let tableName = doc.data()[Constants.FStoreField.Table.tableNames] as! String
                        print(tableName)
                        if tableName == tableN{
                            tableID = doc.data()[Constants.FStoreField.Table.tableID] as! String
                            break
                        }
                        else{
                            print("unable to find table")
                        }
                    }
                }
            }
        }
        return tableID
    }
    
    func updateTableAvailability(_ table:String){
        let tb = db.collection(Constants.FStoreCollection.tables).document(table)
        tb.getDocument { (document, error) in
            if let document = document, document.exists {
                document.setValue(false, forKey: Constants.FStoreField.Table.tableEmpty)
            } else {
                print("document for table does not exist")
            }
        }
        
    }
    
}


// MARK: - Picker View Delegate
extension BookTableViewController: UIPickerViewDelegate,  UIPickerViewDataSource, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return freeTables.count
        case 2:
            return durations.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return freeTables[row]
        case 2:
            return durations[row]
        default:
            return "Data Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch curId{
        case 1:
            tableTxt.text = freeTables[row]
        case 4:
            durationTxt.text = durations[row]
        default:
            print("Error setting nums")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performTransform(false)
        switch textField.tag{
        case 1: //table
            hideAllPicker()
            tablePicker.isHidden = false
            curId = tableID
        case 2: //date
            hideAllPicker()
            datePicker.isHidden = false
            curId = dateId
        case 3: //time
            hideAllPicker()
            timePicker.isHidden = false
            curId = timeId
        case 4: //duration
            hideAllPicker()
            durationPicker.isHidden = false
            curId = durationId
        default:
            print("unknown txt")
        }
    }
    
}


//// MARK: - Custom Picker Delegate
//extension BookTableViewController: BookingPickerDelegate{
//    func didTapDone() {
//        let row = self.numPicker.selectedRow(inComponent: 0)
//        self.numPicker.selectRow(row, inComponent: 0, animated: false)
//        self.numOfPeopleTxt.text = self.numPeople[row]
//        self.numOfPeopleTxt.resignFirstResponder()
//    }
//
//    func didTapCancel() {
//        self.numOfPeopleTxt.text = nil
//        self.numOfPeopleTxt.resignFirstResponder()
//    }
//
//}

    
