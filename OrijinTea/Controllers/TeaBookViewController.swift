//
//  TeaBookViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/5/23.
//

import UIKit

class TeaBookViewController: UIViewController {

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var teaBookTableView: UITableView!
    
    var favProducts:[Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teaBookTableView.delegate = self
        teaBookTableView.dataSource = self
        prepareProducts()
    }
    
    
    func prepareProducts(){
        favProducts = Global.favorites
        DispatchQueue.main.async {
            self.teaBookTableView.reloadData()
        }
    }
    
    
    @IBAction func backBtnPresed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.teaBookToMe, sender: self)
    }
    

}

extension TeaBookViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favProducts.count)
        return favProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teaBookCell", for: indexPath)
        cell.textLabel?.text = favProducts[indexPath.row].productName
        let imageBackground = CustomBackgroundView()
        imageBackground.setImg("Default Cell Img")
        cell.backgroundView = imageBackground
        return cell
    }
    
    
}
