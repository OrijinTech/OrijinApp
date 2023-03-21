//
//  AdmProfileViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/20/23.
//

import UIKit

class AdmProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Admin.toPayHistory{
            let destinationVC = segue.destination as? AdmReservationViewController
            destinationVC?.mode = "paymentHistory"
        }
    }
    

    
    @IBAction func paymentHist(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.toPayHistory, sender: self)
    }
    

}
