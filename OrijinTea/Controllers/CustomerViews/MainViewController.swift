//
//  MainViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//



import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


class MainViewController: UIViewController, UIScrollViewDelegate{

    let db = Firestore.firestore()
    
    // UIView Outlet
    @IBOutlet weak var collapsibleView: UIView!
    @IBOutlet weak var onlineShoppingView: UIView!
    @IBOutlet weak var visitOrijinView: UIView!
    
    // Constraints Outlet
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    // Scroll View Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Image View outlet
    @IBOutlet weak var onlineShoppingImg: UIImageView!
    @IBOutlet weak var visitOrijinImg: UIImageView!
    @IBOutlet weak var profilePicImg: UIImageView!
    
    // Button Outlets
    @IBOutlet weak var onlineShoppingBtn: UIButton!
    @IBOutlet weak var visitOrijinBtn: UIButton!
    
    // Text Outlet
    @IBOutlet weak var welcomeTxt: UITextView!
    
    // Value Variables
    var lastContentOffset: CGFloat = 0
    let maxHeaderHeight: CGFloat = 150
    let minHeaderHeight: CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepareUser() // ENTRY POINT OF THE USER'S APP, PREPARE USER DATA
        self.scrollView.delegate = self
        // View/Graphic Settings
        onlineShoppingView.layer.cornerRadius = 12
        onlineShoppingView.layer.borderWidth = 1
        onlineShoppingView.layer.borderColor = UIColor.lightGray.cgColor
        onlineShoppingImg.layer.cornerRadius = 12
        profilePicImg.layer.cornerRadius = 40
        visitOrijinView.layer.cornerRadius = 12
        visitOrijinView.layer.borderWidth = 1
        visitOrijinView.layer.borderColor = UIColor.lightGray.cgColor
        visitOrijinImg.layer.cornerRadius = 12
        // Set up shadows
        collapsibleView.layer.shadowColor = UIColor.black.cgColor
        collapsibleView.layer.shadowOffset = CGSize(width: 3, height: 3)
        collapsibleView.layer.shadowOpacity = 0.8
        collapsibleView.layer.shadowRadius = 6
        collapsibleView.clipsToBounds = true
        // Set Welcome Text
        self.welcomeTxt.text = "Welcome Back, \n" + Global.User.userName
        // Get User Data
        Global.getFavoriteProducts {
            Global.convertFavProdctToObj()
        }
        // set profile picture
        if let img = Global.User.profileImg{
            self.profilePicImg.image = img
        }
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
    }
    
    
    @objc private func didPullForRefresh(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.profilePicImg.image = Global.User.profileImg
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    
    @IBAction func onlineShoppingPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.mainToShop, sender: self)
    }
    
    
    @IBAction func visitOrijin(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.mainToBook, sender: self)
    }
    
    

    
}

