//
//  InfoViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import UIKit


class InfoViewController: UIViewController{
    
    // View Outlets
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var barcodeView: UIView!
    
    // Textview Outlets
    @IBOutlet weak var profileNameTxt: UITextView!
    
    // Button Outlets
    @IBOutlet weak var profileChange: UIButton!
    @IBOutlet weak var usernameChange: UIButton!
    @IBOutlet weak var passwordChange: UIButton!
    @IBOutlet weak var showBarcode: UIButton!
    @IBOutlet weak var headerBack: UIButton!
    @IBOutlet weak var userBack: UIButton!
    @IBOutlet weak var userSave: UIButton!
    @IBOutlet weak var passwordBack: UIButton!
    @IBOutlet weak var passwordSave: UIButton!
    
    
    // Constraints Outlets
    @IBOutlet weak var usernameHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var profilePicHeight: NSLayoutConstraint!
    @IBOutlet weak var barcodeHeight: NSLayoutConstraint!
    let hideHight = CGFloat(636)
    let showHeight = CGFloat(8)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTagSetup()
        hideAll()
    }
    
    func btnTagSetup(){
        profileChange.tag = 1
        usernameChange.tag = 2
        passwordChange.tag = 3
        showBarcode.tag = 4
        userBack.tag = 5
        userSave.tag = 6
        passwordBack.tag = 7
        passwordSave.tag = 8
    }
    
    func hideAll(){
        // headerBack.isHidden = true
        usernameHeight.constant = hideHight
        passwordHeight.constant = hideHight
        profilePicHeight.constant = hideHight
        barcodeHeight.constant = hideHight
    }
    
    
    func changeScene(for Button: UIButton){
        UIView.animate(withDuration: 0.15) { [self] in
            switch Button.tag{
            case 1:
                hideAll()
                profilePicHeight.constant = showHeight
            case 2:
                hideAll()
                usernameHeight.constant = showHeight
            case 3:
                hideAll()
                passwordHeight.constant = showHeight
            case 4:
                hideAll()
                barcodeHeight.constant = showHeight
            case 5, 7: // popup backbuttons
                hideAll()
                headerBack.isHidden = false
            //case 6:
            //case 8:
            default:
                print("ERROR: Showing supviews in profile information.")
            }
        }
    }
    
    
    @IBAction func usernameBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    
    @IBAction func profilePicBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func passwordBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func showQRBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.profileInfoToMe, sender: self)
    }
    
    @IBAction func userBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    @IBAction func userSaveBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func passwordBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func passwordSaveBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    // Change Username
    
    
    
}
