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
                }
                else {
                    print("Document does not exist")
                }
            }
        }
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.confirmationToMain, sender: self)
    }
    
    
    
}
