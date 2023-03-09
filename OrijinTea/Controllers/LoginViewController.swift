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
    
    let db = Firestore.firestore()
    
    // here we log in the users using email and password
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = usernameField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    self.prepareUser()
                }
            }
        }
    }
    
    
    
    func prepareUser(){
        if let curUser = Auth.auth().currentUser?.email{
            let col = db.collection(Constants.FStoreCollection.users)
            let docRef = col.document(curUser)
            docRef.getDocument { docSnap, error in
                if let e = error{
                    print("Error: Getting the user name. \(e)")
                }
                else{
                    if let userN = docSnap?.data()![Constants.FStoreField.Users.userName] as? String{
                        let uid = docSnap?.data()![Constants.FStoreField.Users.id] as! String
                        let firstN = docSnap?.data()![Constants.FStoreField.Users.firstName] as! String
                        let lastN = docSnap?.data()![Constants.FStoreField.Users.lastName] as! String
                        let email = docSnap?.data()![Constants.FStoreField.Users.email] as! String
                        let teaPts = docSnap?.data()![Constants.FStoreField.Users.teaPoints] as! Int
                        let userType = docSnap?.data()![Constants.FStoreField.Users.userType] as! String
                        Global.User.userName = userN
                        Global.User.firstName = firstN
                        Global.User.lastName = lastN
                        Global.User.email = email
                        Global.User.id = uid
                        Global.User.teaPoints = teaPts
                        Global.User.userType = userType
                        print("success pulling the user")
                        if userType == "admin"{
                            self.performSegue(withIdentifier: Constants.Admin.loginToAdmAcc, sender: self)
                        }
                        else if userType == "customer"{
                            self.performSegue(withIdentifier: Constants.loginToMain, sender: self)
                        }
                        else{
                            print("ERROR: Unable to fetch user type.")
                        }
                    }
                    else{
                        print("Error loading user")
                    }
                }
            }
        }
    }

    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.loginToSign, sender: self)
    }
    
    
    
}
