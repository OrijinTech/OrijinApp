//
//  ComfirmViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/21/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


class ComfirmViewController: UIViewController {

    // Database Reference
    let db = Firestore.firestore()
    
    // Textfield reference
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    @IBOutlet weak var tableTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    
    // Image View Reference
    @IBOutlet weak var topImg: UIImageView!
    
    var curTableSelected = ""
    var bookedTable = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInformation()
        addressTxt.text = "Charvatova 1988/3"
    }
    
    func setInformation(){
        if let messageSender = Auth.auth().currentUser?.email{
            let doc = db.collection(Constants.FStoreCollection.reservations).document(messageSender)
            doc.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.dateTxt.text = document.get(Constants.FStoreField.Reservation.date) as? String
                    self.timeTxt.text = document.get(Constants.FStoreField.Reservation.time) as? String
                    self.durationTxt.text = document.get(Constants.FStoreField.Reservation.duration) as? String
                    self.tableTxt.text = document.get(Constants.FStoreField.Reservation.tableNumber) as? String
                    self.calcTableID(self.tableTxt.text!)
                }
                else {
                    print("Document does not exist")
                }
            }
            print("inside setInfo")
        }
    }
    
    func calcTableID(_ tableN: String){
        db.collection(Constants.FStoreCollection.tables).getDocuments { querySnap, error in
            if let e = error{
                print("there was an issue retreiving from FIRESTORE \(e)")
            }
            else{
                if let snapDocs = querySnap?.documents{
                    for doc in snapDocs{
                        let data = doc.data()
                        let tableName = data[Constants.FStoreField.Table.tableNames] as! String
                        let curTbId = data[Constants.FStoreField.Table.tableID] as! String
                        if tableName == tableN {
                            print("Found table" + tableName)
                            self.updateTableAvailability(curTbId)
                            break
                        }
                        else{
                            print("unable to find table")
                        }
                    }
                }
            }
        }
    }
    
    
    func updateTableAvailability(_ table:String){
        let tb = db.collection(Constants.FStoreCollection.tables).document(table)
        tb.getDocument { (document, error) in
            if let document = document, document.exists {
                tb.updateData([Constants.FStoreField.Table.tableEmpty : false])
                //document.setValue(false, forKey: Constants.FStoreField.Table.tableEmpty)
            } else {
                print("document for table does not exist")
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.confirmationToMain, sender: self)
    }
    
    
    
}
