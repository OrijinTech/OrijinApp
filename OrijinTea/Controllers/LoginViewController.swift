//
//  LoginViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/6/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // here we log in the users using email and password
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = usernameField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    self.performSegue(withIdentifier: "loginToMain", sender: self)
                }
            }
        }
    }
    
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.loginToSign, sender: self)
    }
    
    
}
