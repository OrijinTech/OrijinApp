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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func profileInfoPressed(_ sender: UIButton) {
        
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
