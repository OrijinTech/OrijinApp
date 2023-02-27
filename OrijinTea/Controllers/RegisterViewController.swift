//
//  SignUpViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/6/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController {


    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    let db = Firestore.firestore()
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //This allows us to sign up users, store user cred into firestore, and jump to the main screen
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else {
                    // Save the user profile to firestore
                    if let curUser = Auth.auth().currentUser?.email{
                        let curUserId = Auth.auth().currentUser?.uid
                        let saveUser = Users(id: curUserId!, firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, email: curUser)
                        do{
                            try self.db.collection(Constants.FStoreCollection.users).document(curUser).setData(from:saveUser)
                            self.performSegue(withIdentifier: Constants.signToMain, sender: self)
                        }
                        catch let error{
                            print("Error writing user to Firestore: \(error)")
                        }
                    }
                    
                }
            }

            
        }
        
    }
    
    
    @IBAction func toLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.signToLogin, sender: self)
    }


}
