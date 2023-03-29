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
import FirebaseStorage
import SDWebImage

class InfoViewController: UIViewController{
    
    let db = Firestore.firestore()
    // Timer variables
    var timer = Timer()
    var secondsRemaining = 60
    // ImagePicker
    let imagePicker = UIImagePickerController()
    
    // View Outlets
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var barcodeView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    // Textview Outlets
    @IBOutlet weak var profileNameTxt: UITextView!
    
    //TextField Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passResetEmailTxt: UITextField!
    
    // Label Outlets
    @IBOutlet weak var passResetConfirmationTxt: UILabel!
    @IBOutlet weak var confirmationTxt: UILabel!
    
    // Image Outlet
    @IBOutlet weak var barcodeImgView: UIImageView!
    @IBOutlet weak var profilePicPreview: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    
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
    @IBOutlet weak var profileBack: UIButton!
    
    // Constraints Outlets
    @IBOutlet weak var usernameHeight: NSLayoutConstraint!
    @IBOutlet weak var profilePicHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var barcodeHeight: NSLayoutConstraint!
    @IBOutlet weak var collapsViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileNameTxt.text = Global.User.userName
        btnTagSetup()
        hideAll()
        imagePicker.delegate = self
        if let img = Global.User.profileImg{
            self.profileImg.image = img
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Global.getUserProfilePicture { image in
            if let image = image{
                Global.User.profileImg = image
            }
            self.profileImg.layoutIfNeeded()
            print("back to main menu")
        }
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
        profileBack.tag = 9
    }
    

    func hideAll(){
        usernameView.isHidden = true
        passwordView.isHidden = true
        profilePicView.isHidden = true
        barcodeView.isHidden = true
        collapsViewHeight.constant = 150
    }
    
    func changeScene(for Button: UIButton){
        UIView.animate(withDuration: 0.15) { [self] in
            switch Button.tag{
            case 1:
                hideAll()
                headerBack.isHidden = true
                profilePicView.isHidden = false
            case 2:
                hideAll()
                headerBack.isHidden = true
                usernameView.isHidden = false
            case 3:
                hideAll()
                headerBack.isHidden = true
                passwordView.isHidden = false
            case 4:
                hideAll()
                headerBack.isHidden = true
                barcodeView.isHidden = false
            case 5, 6, 7, 8, 9: // popup backbuttons
                hideAll()
                headerBack.isHidden = false
            default:
                print("ERROR: Showing supviews in profile information.")
            }
            collapsViewHeight.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func usernameBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    
    
    @IBAction func profilePicBtn(_ sender: UIButton) {
        profilePicPreview.layer.borderWidth = 1.0
        profilePicPreview.layer.borderColor = UIColor.gray.cgColor
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
    
    // Username Change
    @IBAction func userBackBtn(_ sender: UIButton) {
        changeScene(for: sender)
    }
    
    @IBAction func userSaveBtn(_ sender: UIButton) {
        changeUsername()
        changeScene(for: sender)
    }
    
    // Password Change
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
    
    // Profile Pic Change
    @IBAction func profilePicBackBtn(_ sender: UIButton) {
        profilePicPreview.image = nil
        changeScene(for: sender)
    }
    
    @IBAction func selectImgBtn(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func profilePicSave(_ sender: UIButton) {
        if profilePicPreview.image != nil{
            let storageRef = Storage.storage().reference()
            let imageName = Global.User.email + "profileImg"
            let imageData = profilePicPreview.image!.jpegData(compressionQuality: 0.8)
            let imageRef = storageRef.child("images/\(imageName)")
            let docRef = db.collection(Constants.FStoreCollection.users).document(Global.User.email)
            // Create a dictionary with the image metadata or download URL
            _ = imageRef.putData(imageData!, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    // Image uploaded successfully, save the download URL to Firestore, to the current user
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error retrieving download URL: \(error.localizedDescription)")
                        } else if let url = url {
                            // Save the download URL to Firestore
                            docRef.setData(["profileImg": url.absoluteString], merge: true) { error in
                                if let error = error {
                                    print("Error saving profile image URL: \(error.localizedDescription)")
                                } else {
                                    print("Profile image URL saved to Firestore")
                                    self.confirmationTxt.text = "Profile image saved successfully!"
                                }
                            }
                        }
                    }
                }
            }
        }
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
    func generateBarCode(from user: String) -> UIImage? {
        guard let data = user.data(using: .ascii, allowLossyConversion: false) else {
            return nil
        }
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let qrImage = qrFilter?.outputImage else {
            return nil
        }
        
        let scaleX = barcodeImgView.frame.size.width / qrImage.extent.size.width
        let scaleY = barcodeImgView.frame.size.height / qrImage.extent.size.height
        
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return UIImage(ciImage: transformedImage)
    }
    
    
    func showBarCode(){
        let barcodeImg = generateBarCode(from: Global.User.email)
        barcodeImgView.image = barcodeImg
    }
    

}

extension InfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected image from the info dictionary.
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profilePicPreview.image = image
        profilePicPreview.clipsToBounds = true
        // Dismiss the image picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
}
