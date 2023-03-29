//
//  BookingViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//

import UIKit


class BookingViewController: UIViewController, UIScrollViewDelegate{
    
    // UIView Outlet
    
    @IBOutlet weak var collapsibleView: UIView!
    @IBOutlet weak var occupancyView: UIView!
    @IBOutlet weak var bookTableView: UIView!
    
    // Constraints Outlet
    @IBOutlet weak var collapsViewHeight: NSLayoutConstraint!
    
    
    // Scroll View Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Image View outlet
    @IBOutlet weak var occupancyImg: UIImageView!
    @IBOutlet weak var bookTableImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    
    // Button Outlets
    @IBOutlet weak var occupancyBtn: UIButton!
    @IBOutlet weak var bookTableBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    // Value Variables
    var lastContentOffset: CGFloat = 0
    let maxHeaderHeight: CGFloat = 150
    let minHeaderHeight: CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        // View/Graphic Settings
        occupancyView.layer.cornerRadius = 12
        occupancyView.layer.borderWidth = 1
        occupancyView.layer.borderColor = UIColor.lightGray.cgColor
        occupancyView.layer.cornerRadius = 12
        bookTableView.layer.cornerRadius = 12
        bookTableView.layer.borderWidth = 1
        bookTableView.layer.borderColor = UIColor.lightGray.cgColor
        bookTableView.layer.cornerRadius = 12
        occupancyImg.layer.cornerRadius = 12
        bookTableImg.layer.cornerRadius = 12
        profileImg.layer.cornerRadius = 40
        // Set up shadows
        collapsibleView.layer.shadowColor = UIColor.black.cgColor
        collapsibleView.layer.shadowOffset = CGSize(width: 3, height: 3)
        collapsibleView.layer.shadowOpacity = 0.8
        collapsibleView.layer.shadowRadius = 6
        collapsibleView.clipsToBounds = true
        // set profile picture
        if let img = Global.User.profileImg{
            self.profileImg.image = img
        }
        
    }
    

    // SCROLLING ISSUE !!!
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
//            //Scrolled to bottom
//            UIView.animate(withDuration: 0.3) {
//                self.collapsViewHeight.constant = self.minHeaderHeight
//                self.view.layoutIfNeeded()
//            }
//
//        }
//        else if (scrollView.contentOffset.y == 0 && self.collapsViewHeight.constant <= maxHeaderHeight){
//            // scrolled to top --> https://stackoverflow.com/questions/56557078/how-to-implement-a-collapsing-header
//            UIView.animate(withDuration: 0.3) {
//                self.collapsViewHeight.constant = self.maxHeaderHeight
//                self.view.layoutIfNeeded()
//            }
//        }
//
//        else if (scrollView.contentOffset.y > self.lastContentOffset) && self.collapsViewHeight.constant != minHeaderHeight {
//            //Scrolling down
//            UIView.animate(withDuration: 0.3) {
//                self.collapsViewHeight.constant = self.minHeaderHeight
//                self.view.layoutIfNeeded()
//            }
//        }
//        self.lastContentOffset = scrollView.contentOffset.y
//    }

    

    @IBAction func backPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.visitToMain, sender: self)
    }
    
    
    @IBAction func occupancyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.toTableOccupancy, sender: self)
    }
    
    
    @IBAction func bookTablePressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.bookToBookTable, sender: self)
    }
    
    
}
