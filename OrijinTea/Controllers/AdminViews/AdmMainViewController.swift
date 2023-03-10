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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Button Press
    @IBAction func manageResBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admToAllReservations, sender: self)
    }
    
    
    @IBAction func tbManagerBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admMainToTables, sender: self)
    }
    
    
    
}
