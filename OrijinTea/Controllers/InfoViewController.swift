//
//  InfoViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class InfoViewController: UIViewController{
    
    let db = Firestore.firestore()
    // Timer variables
    var timer = Timer()
    var secondsRemaining = 60
    
    // View Outlets
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var barcodeView: UIView!
    
    // Textview Outlets
    @IBOutlet weak var profileNameTxt: UITextView!
    
    //TextField Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passResetEmailTxt: UITextField!
    
    // Label Outlets
    @IBOutlet weak var passResetConfirmationTxt: UILabel!
    
    // Image Outlet
    @IBOutlet weak var barcodeImgView: UIImageView!
    
    
    // Button Outlets
    @IBOutlet weak var profileChange: UIButton!
    @IBOutlet weak var usernameChange: UIButton!
    @IBOutlet weak var passwordChange: UIButton!
    @IBOutlet weak var showBarcode: UIButton!
    @IBOutlet weak var headerBack: UIButton!
    @IBOutlet weak var userBack: UIButton!
    @IBOutlet weak var userSave: UIButton!
    @IBOutlet weak var passwordBack: UIButton!
    @IBOutlet weak var sendResetLink: UIButton!
    @IBOutlet weak var qrcodeBack: UIButton!
    
    
    
    // Constraints Outlets
    @IBOutlet weak var usernameHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var profilePicHeight: NSLayoutConstraint!
    @IBOutlet weak var barcodeHeight: NSLayoutConstraint!
    let hideHight = CGFloat(636)
    let showHeight = CGFloat(8)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.text = Global.User.userName
        profileNameTxt.text = Global.User.userName
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
        qrcodeBack.tag = 8
        
    }
    
    func hideAll(){
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
                headerBack.isHidden = true
                profilePicHeight.constant = showHeight
            case 2:
                hideAll()
                headerBack.isHidden = true
                usernameHeight.constant = showHeight
            case 3:
                hideAll()
                headerBack.isHidden = true
                passwordHeight.constant = showHeight
            case 4:
                hideAll()
                headerBack.isHidden = true
                barcodeHeight.constant = showHeight
            case 5, 6, 7, 8: // popup backbuttons
                hideAll()
                headerBack.isHidden = false
            default:
                print("ERROR: Showing supviews in profile information.")
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func usernameBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    
    @IBAction func profilePicBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    @IBAction func passwordBtn(_ sender: UIButton) {
        passResetEmailTxt.text = Global.User.email
        changeScene(for: sender)
    }
    
    
    @IBAction func showQRBtn(_ sender: UIButton) {
        changeScene(for: sender)
        showBarCode()
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.profileInfoToMe, sender: self)
    }
    
    @IBAction func userBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    @IBAction func userSaveBtn(_ sender: UIButton) {
        changeUsername()
        changeScene(for: sender)
    }
    
    
    @IBAction func passwordBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    @IBAction func sendResetBtn(_ sender: UIButton) {
        sendPasswordResetEmail()
        secondsRemaining = 60
        sendResetLink.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func qrcodeBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    
    @objc func updateTimer(){
        if secondsRemaining > 0{
            secondsRemaining -= 1
            sendResetLink.setTitle(String(secondsRemaining), for: .normal)
        }
        else{
            timer.invalidate()
            sendResetLink.isUserInteractionEnabled = true
            sendResetLink.setTitle("Send", for: .normal)
        }
    }
    
    // MARK: - Username change function
    func changeUsername(){
        if usernameTxt.text != "" && usernameTxt.text!.count <= 12{
            let newUsername = usernameTxt.text!
            let collectionRef = db.collection(Constants.FStoreCollection.users)
            let docRef = collectionRef.document(Global.User.email)
            
            docRef.getDocument { qsnap, error in
                if let e = error{
                    print("Error: Retreiving booking ID: \(e)")
                }
                else{
                    if let doc = qsnap, doc.exists{
                        // update the username
                        docRef.updateData([Constants.FStoreField.Users.userName : newUsername]){ error in
                            if let error = error {
                                print("Error updating document: \(error.localizedDescription)")
                            } else {
                                Global.User.userName = newUsername
                                DispatchQueue.main.async {
                                    self.profileNameTxt.reloadInputViews()
                                }
                                print("Username updated successfully")
                            }
                        }
                    }
                    else{
                        print("The user does not exist!")
                    }
                }
            }
        }
        else{
            print("The username must be less than 12 characters.")
        }
    }
    
    // MARK: - passowrd reset function
    func sendPasswordResetEmail() {
        let email = Global.User.email
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                self.passResetConfirmationTxt.text = "An email has been sent to the above address with a password reset link."
                print("Password reset email sent successfully")
            }
        }
    }
    
    
    // MARK: - Barcode functions
    func generateBarCode(from user: String) -> UIImage?{
        let data = user.data(using: String.Encoding.ascii)
       
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let output = filter.outputImage {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func showBarCode(){
        let barcodeImg = generateBarCode(from: Global.User.email)
        barcodeImgView.image = barcodeImg
    }
    
    
}
