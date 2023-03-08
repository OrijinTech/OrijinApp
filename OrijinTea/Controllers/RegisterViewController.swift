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
                        let saveUser = Users(id: curUserId!, firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, email: curUser, userName: curUser)
                        do{
                            try self.db.collection(Constants.FStoreCollection.users).document(curUser).setData(from:saveUser)
                            self.prepareUser()
                        }
                        catch let error{
                            print("Error writing user to Firestore: \(error)")
                        }
                    }
                    
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
                        Global.User.userName = userN
                        Global.User.firstName = firstN
                        Global.User.lastName = lastN
                        Global.User.email = email
                        Global.User.id = uid
                        Global.User.teaPoints = teaPts
                        print("success pulling the user")
                        self.performSegue(withIdentifier: Constants.signToMain, sender: self)
                    }
                    else{
                        print("Error loading user")
                    }
                }
            }
        }
    }
    
    
    @IBAction func toLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.signToLogin, sender: self)
    }


}
