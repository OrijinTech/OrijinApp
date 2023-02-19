//
//  BookTableViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/13/23.
//

import UIKit

class BookTableViewController: UIViewController{
    
    // Constraints Outlets
    @IBOutlet weak var stackDist: NSLayoutConstraint!
    @IBOutlet weak var bookTableDist: NSLayoutConstraint!
    
    // Textfield Outlets
    @IBOutlet weak var numOfPeopleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    
    // Picker View Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // View Outlets
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var pickViewHeight: NSLayoutConstraint!
    
    
    let nums = ["1", "2", "3", "4", "5", "6", "more"]
    var curId = 0
    let numId = 1
    let dateId = 2
    let timeId = 3
    let durationId = 4
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegates
        numOfPeopleTxt.delegate = self
        dateTxt.delegate = self
        timeTxt.delegate = self
        durationTxt.delegate = self
        numPicker.delegate = self
        // datasources
        numPicker.dataSource = self
        // setting colors
        datePicker.setValue(UIColor.init(red: 149, green: 145, blue: 85, alpha: 1), forKey: "backgroundColor")
        timePicker.setValue(UIColor.lightGray, forKey: "backgroundColor")
        // tag distribution
        numOfPeopleTxt.tag = 1
        dateTxt.tag = 2
        timeTxt.tag = 3
        durationTxt.tag = 4
        // initial graphic states
        performTransform(true)
        // add listeners
        datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(onTimeValueChanged(_:)), for: .valueChanged)
        
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
    
    @IBAction func bookTableBtn(_ sender: UIButton) {
        print("Booked a Table")
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        hideAllPicker()
        performTransform(true)
    }
    
    func hideAllPicker(){
        datePicker.isHidden = true
        timePicker.isHidden = true
        numPicker.isHidden = true
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        switch curId{
        case 1:
            let row = numPicker.selectedRow(inComponent: 0)
            numPicker.selectRow(row, inComponent: 0, animated: false)
            numOfPeopleTxt.text = nums[row]
            numOfPeopleTxt.resignFirstResponder()
            performTransform(true)
        case 2:
            dateTxt.resignFirstResponder()
            performTransform(true)
        case 3:
            timeTxt.resignFirstResponder()
            performTransform(true)
        case 4:
            let row = numPicker.selectedRow(inComponent: 0)
            numPicker.selectRow(row, inComponent: 0, animated: false)
            durationTxt.text = nums[row]
            durationTxt.resignFirstResponder()
            performTransform(true)
        default:
            print("error done")
        }

    }
    
    
}


// MARK: - Picker View Delegate
extension BookTableViewController: UIPickerViewDelegate,  UIPickerViewDataSource, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        nums[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch curId{
        case 1:
            numOfPeopleTxt.text = nums[row]
        case 4:
            durationTxt.text = nums[row]
        default:
            print("error setting nums")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performTransform(false)
        switch textField.tag{
        case 1: //num of ppl
            hideAllPicker()
            numPicker.isHidden = false
            curId = numId
        case 2: //date
            hideAllPicker()
            datePicker.isHidden = false
            curId = dateId
        case 3: //time
            hideAllPicker()
            timePicker.isHidden = false
            curId = timeId
        case 4: // duration
            hideAllPicker()
            numPicker.isHidden = false
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

    
