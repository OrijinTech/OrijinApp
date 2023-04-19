//
//  TeaMenuViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 4/19/23.
//

import UIKit

class TeaMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Shop.menuToTeashop, sender: self)
    }
    
}
