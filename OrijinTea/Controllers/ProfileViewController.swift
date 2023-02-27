//
//  ProfileViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


class ProfileViewController: UIViewController {
    
    // Image outlet
    @IBOutlet weak var profileImg: UIImageView!
    // Label outlet
    @IBOutlet weak var userNameTxt: UILabel!
    
    @IBOutlet var masterView: UIView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxt.text = Global.User.userName
    }
    
    
    @IBAction func profileInfoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.profileToInfo, sender: self)
    }
    
    @IBAction func reservationsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.profileToReservations, sender: self)
    }
    
    @IBAction func teaBookPressed(_ sender: UIButton) {
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: Constants.Me.meToLogin, sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    

    
}
