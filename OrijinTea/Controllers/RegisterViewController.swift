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

class RegisterViewController: UIViewController {


    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //This allows us to sign up users, store user cred into firestore, and jump to the main screen
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else {
                    self.performSegue(withIdentifier: Constants.signToMain, sender: self)
                }
            }
        }
        
    }
    
    
    @IBAction func toLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.signToLogin, sender: self)
    }


}
