//
//  ViewReservationViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/22/23.
//

import UIKit

class ViewReservationViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    @IBOutlet weak var tableTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var popupWindow: UIView!
    @IBOutlet weak var deleteBookingBtn: UIButton!
    @IBOutlet weak var blurView: UIView!
    
    // accepting data from previous segue
    var date = ""
    var time = ""
    var duration = ""
    var table = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupWindow.isHidden = true
        dateTxt.text = date
        timeTxt.text = time
        durationTxt.text = duration
        tableTxt.text = table
        addressTxt.text = Constants.TextCont.orijinAddress
    }
    
    func setPopup(){
        popupWindow.layer.cornerRadius = 3
        popupWindow.layer.borderWidth = 3
        popupWindow.layer.borderColor = UIColor.systemGray.cgColor
        
    }
    
    func setBlur(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = CGRect(x: 0, y: 0, width: blurView.frame.width, height: blurView.frame.height)
        blurEffectView.center = blurView.center
        self.blurView.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.2, delay: 0) {
            blurEffectView.effect = blurEffect
            print("reached 1")
        }
        self.popupWindow.isHidden = false
        self.setPopup()
        self.blurView.addSubview(popupWindow)
    }
    
    
    @IBAction func deletePressed(_ sender: UIButton) {
        deleteBookingBtn.isUserInteractionEnabled = false
        setBlur()

    }
    
    @IBAction func confirmDelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        for subview in blurView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        popupWindow.isHidden = true
        deleteBookingBtn.isUserInteractionEnabled = true
    }
    

}
