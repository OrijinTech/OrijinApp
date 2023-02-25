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
    @IBOutlet weak var pickViewHeight: NSLayoutConstraint!
    
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
    @IBOutlet weak var clickView: UIView!
    
    // Button outlets
    @IBOutlet weak var bookBtnOutlet: UIButton!
    
    var freeTables = [String](repeating: "", count: 5)
    var reservations = [Reservation]()
    let durations = ["1", "2", "3", "4", "5"]
    var curId = 0
    let tableID = 1
    let dateId = 2
    let timeId = 3
    let durationId = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        // delegates
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
        clickView.addGestureRecognizer(tapGesture)
        //disable textfields to avoid errors
        enableAllTextFields(false)
        // set textfield input view
        tableTxt.inputView = tablePicker
        durationTxt.inputView = durationPicker
    }
    
    
    // hiding the pick view and transforming the book table btn
    func performTransform(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.bookTableDist.constant = 30
                self.bookBtnOutlet.isHidden = false
                self.pickViewHeight.constant = 0
                self.stackDist.constant = 100
                self.view.layoutIfNeeded()
            }
            
        }
        else{ //pick view expanded
            UIView.animate(withDuration: 0.15) {
                self.bookTableDist.constant = 8
                self.bookBtnOutlet.isHidden = true
                self.pickViewHeight.constant = 350
                self.stackDist.constant = 30
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func hideAllPicker(){
        datePicker.isHidden = true
        timePicker.isHidden = true
        tablePicker.isHidden = true
        durationPicker.isHidden = true
    }
    
    
    // MARK: - RESPONSE FUNCTIONS FOR LISTENERS
    
    // When the user taps the surroundings
    @objc func mainViewTapped(){
        switch curId{
        case 1:
            tableTxt.resignFirstResponder()
            tableTxt.text = ""
            updateAllowedTextFields(current: tableTxt)
        case 2:
            dateTxt.resignFirstResponder()
            dateTxt.text = ""
            updateAllowedTextFields(current: dateTxt)
        case 3:
            timeTxt.resignFirstResponder()
            timeTxt.text = ""
            updateAllowedTextFields(current: timeTxt)
        case 4:
            durationTxt.resignFirstResponder()
            durationTxt.text = ""
            updateAllowedTextFields(current: durationTxt)
        default:
            print("error in mainViewTapped")
        }
        // dismiss textfield selections
        performTransform(true)
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
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        switch curId{
        case 1: // picked table
            updateAllowedTextFields(current: tableTxt)
            let row = tablePicker.selectedRow(inComponent: 0)
            tablePicker.selectRow(row, inComponent: 0, animated: false)
            tableTxt.text = freeTables[row]
            tableTxt.resignFirstResponder()
            performTransform(true)
        case 2: // picked date
            updateAllowedTextFields(current: dateTxt)
            dateTxt.resignFirstResponder()
            performTransform(true)
            getAvailableTables()
        case 3: // picked time
            updateAllowedTextFields(current: timeTxt)
            timeTxt.resignFirstResponder()
            performTransform(true)
            getAvailableTables()
        case 4: // picked duration
            updateAllowedTextFields(current: durationTxt)
            let row = durationPicker.selectedRow(inComponent: 0)
            durationPicker.selectRow(row, inComponent: 0, animated: false)
            durationTxt.text = durations[row]
            durationTxt.resignFirstResponder()
            performTransform(true)
            getAvailableTables()
        default:
            print("error done")
        }
        
    }
    
    // MARK: - Data Retreival
    
    // Reloads the available tables
    func getAvailableTables(){
        reservations.removeAll()
        freeTables.removeAll()
        if reloadReservations(){
            print(dateTxt.text!)
            loadReservations(forFormattedDate: dateTxt.text!)
        }
        if reloadTables() {
            let inpDate = timeStringtoTime(timeTxt.text!)
            loadTables(forTime: inpDate)
        }
    }

    
    // Get all free tables
    func loadTables(forTime time: Date){
        print("start laoding tables")
        freeTables.removeAll()
        db.collection(Constants.FStoreCollection.tables).getDocuments { querySnapshot, error in
            if let e = error{
                print("Issue retreiving current free tables: \(e)")
            }
            else{
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let tableNameSelected = doc.data()[Constants.FStoreField.Table.tableNames] as! String
                        var addToList = true // flag for adding tables
                        if self.reservations.count >= 1{
                            for reservation in self.reservations { // for each reservation, check for time conflicts
                                // calculating the time bounds
                                let startTime = self.timeStringtoTime(reservation.time)
                                let startMin = self.timeToMinutes(fullDate: startTime)
                                let endMin = startMin + Int(reservation.duration)! * 60
                                let inpTimeMin = self.timeToMinutes(fullDate: time)
                                if (inpTimeMin > startMin && inpTimeMin < endMin) && (tableNameSelected == reservation.tableNumber){ // table already booked
                                    addToList = false
                                    break
                                }
                            }
                        }
                        if addToList{
                            self.freeTables.append(tableNameSelected)
                        }
                    }
                }
            }
            // Reload the table picker with available tables
            print(self.freeTables)
            DispatchQueue.main.async {
                self.tablePicker.reloadAllComponents()
            }
        }
        tableTxt.text = ""
    }
    
    
    func loadReservations(forFormattedDate date: String){
        print("Start loading reservations")
        print(dateTxt.text!)
        reservations.removeAll()
        let collectionRef = db.collection(Constants.FStoreCollection.reservations)
        if let curUser = Auth.auth().currentUser?.email{
            collectionRef.getDocuments { querySnapshot, error in
                if let e = error{
                    print("Issue retreiving current reservations: \(e)")
                }
                else{
                    if let snapDocs = querySnapshot?.documents{
                        for doc in snapDocs{
                            let curDate = doc.data()[Constants.FStoreField.Reservation.date] as! String
                            if date == curDate { //if input date = current selected reservation date
                                let date = doc.data()[Constants.FStoreField.Reservation.date] as! String
                                let time = doc.data()[Constants.FStoreField.Reservation.time] as! String
                                let duration = doc.data()[Constants.FStoreField.Reservation.duration] as! String
                                let tableNum = doc.data()[Constants.FStoreField.Reservation.tableNumber] as! String
                                let createRes = Reservation(user: curUser, date: date, time: time, duration: duration, tableNumber: tableNum)
                                self.reservations.append(createRes)
                            }
                        }
                        // RELOAD TABELS HERE @!!!
                        if self.timeTxt.text != ""{
                            print("Time done inputting.")
                            self.freeTables.removeAll()
                            let inpDate = self.timeStringtoTime(self.timeTxt.text!)
                            self.loadTables(forTime: inpDate)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Date Conversion Methods
    
    // choosing allowed dates and times
    func setDateAndTimeChoices(){
        Formatter.time.defaultDate = Calendar.current.startOfDay(for: Date())
        let minimumDate = Formatter.time.date(from: "10:00")!
        let maximumDate = Formatter.time.date(from: "20:00")!
        timePicker.date = minimumDate
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 30
        timePicker.minimumDate = minimumDate
        timePicker.maximumDate = maximumDate
        datePicker.minimumDate = Date()
    }
    
    // Input = String, Output = Date
    func timeStringtoTime(_ strDate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:strDate)!
        return date
    }

    // Input = Date , Output = "yyyy-MM-dd" String format
    func dateToStr(_ date: Date) -> String{
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        return dFormatter.string(from: date)
    }
    
    // Input = String, Output = Date
    func strToDate(_ date: String) -> Date{
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        return dFormatter.date(from: date)!
    }
    
    // Convert the time in HH:mm to number of minutes
    func timeToMinutes(fullDate date: Date) -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        return minute + hour * 60
    }
    
    
    // MARK: - Input Checking
    func isFilled() -> Bool{
        if timeTxt.text == "" || dateTxt.text == "" || durationTxt.text == "" || tableTxt.text == ""{
            return false
        }
        else{
            return true
        }
    }
    
    
    func reloadTables() -> Bool{
        if(dateTxt.text != "" && timeTxt.text != "" && durationTxt.text != ""){
            return true
        }
        else{
            return false
        }
    }
    
    func reloadReservations() -> Bool{
        if(dateTxt.text != ""){
            return true
        }
        else{
            return false
        }
    }
    
    
    func enableAllTextFields(_ trigger: Bool){
        timeTxt.isUserInteractionEnabled = trigger
        durationTxt.isUserInteractionEnabled = trigger
        tableTxt.isUserInteractionEnabled = trigger
    }
    
    // update before and after user clicks on the textfield
    func updateAllowedTextFields(current textField: UITextField){
        enableAllTextFields(false)
        switch textField.tag{
        case 1: // user is selecting table
            enableAllTextFields(true)
        case 2: // user is selecting date
            if(dateTxt.text != ""){
                timeTxt.isUserInteractionEnabled = true
            }
            if reloadTables(){
                tableTxt.isUserInteractionEnabled = true
                durationTxt.isUserInteractionEnabled = true
            }
        case 3: // user is selecting time
            timeTxt.isUserInteractionEnabled = true
            if(timeTxt.text != ""){
                durationTxt.isUserInteractionEnabled = true
            }
            if reloadTables(){
                tableTxt.isUserInteractionEnabled = true
                durationTxt.isUserInteractionEnabled = true
            }
        case 4: // user is selecting duration
            timeTxt.isUserInteractionEnabled = true
            durationTxt.isUserInteractionEnabled = true
            if(durationTxt.text != ""){
                tableTxt.isUserInteractionEnabled = true
            }
        default:
            print("no textField selected")
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
        case 1: // When user is picking a table
            tableTxt.text = freeTables[row]
        case 4:
            durationTxt.text = durations[row]
        default:
            print("Error setting nums")
        }
    }
    
    // HERE IS AN ISSUE: NOW USER MUST PRESS DONE SO TABLE RELOADS
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAllowedTextFields(current: textField)
        switch textField.tag{
        case 2: // after user inputs the date textfield
            // get all reservation based on the date inputed by the user
            updateAllowedTextFields(current: textField)
        case 3: // after user inputs the time textfield
            // convert input date into the Date object
            updateAllowedTextFields(current: textField)
        case 4:
            updateAllowedTextFields(current: textField)
        default:
            print("error after editing text field")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performTransform(false)
        switch textField.tag{
        case 1: // user is selecting table
            hideAllPicker()
            tablePicker.isHidden = false
            curId = tableID
        case 2: // user is selecting date
            hideAllPicker()
            setDateAndTimeChoices()
            datePicker.isHidden = false
            curId = dateId
        case 3: // user is selecting time
            hideAllPicker()
            setDateAndTimeChoices()
            timePicker.isHidden = false
            curId = timeId
        case 4: // user is selecting duration
            hideAllPicker()
            durationPicker.isHidden = false
            curId = durationId
        default:
            print("unknown txt")
        }
        updateAllowedTextFields(current: textField)
    }
    
}


// MARK: - Time Formatter
extension Formatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "em_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
