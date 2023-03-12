//
//  AdmMainViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/9/23.
//

import UIKit

class AdmMainViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var manageResView: UIView!
    @IBOutlet weak var resImg: UIImageView!
    @IBOutlet weak var manageTableView: UIView!
    @IBOutlet weak var tableImg: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageResView.layer.cornerRadius = 12
        manageResView.layer.borderWidth = 1
        manageResView.layer.borderColor = UIColor.lightGray.cgColor
        resImg.layer.cornerRadius = 12
        manageTableView.layer.cornerRadius = 12
        manageTableView.layer.borderWidth = 1
        manageTableView.layer.borderColor = UIColor.lightGray.cgColor
        tableImg.layer.cornerRadius = 12
    }
    
    
    // Button Press
    @IBAction func manageResBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admToAllReservations, sender: self)
    }
    
    
    @IBAction func tbManagerBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admMainToTables, sender: self)
    }
    
    
    
}
