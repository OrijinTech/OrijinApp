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
    
    // Prepare for Segue
    var chosenProduct: Product = Product()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teaBookTableView.delegate = self
        teaBookTableView.dataSource = self
        teaBookTableView.rowHeight = 100
        prepareProducts()
    }
    
    
    func prepareProducts(){
        print("LOADING PRODUCTS")
        favProducts = Global.favorites
        DispatchQueue.main.async {
            self.teaBookTableView.reloadData()
        }
    }
    
    
    @IBAction func backBtnPresed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Me.teaBookToMe, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Me.toSpecificProductInMe{
            let destinationVC = segue.destination as? SpecificProductViewController
            destinationVC?.chosenProduct = chosenProduct
            destinationVC?.incomingSegue = Constants.Me.toSpecificProductInMe
        }
    }
    
}

extension TeaBookViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teaBookCell", for: indexPath)
        if #available(iOS 15.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = Global.textLimiter(favProducts[indexPath.row].productName!, 6)
            config.textProperties.numberOfLines = 0
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = Global.textLimiter(favProducts[indexPath.row].productName!, 6)
            cell.textLabel?.numberOfLines = 0
        }
        
        let imageBackground = CustomBackgroundView()
        imageBackground.setImg("Default Cell Img")
        cell.backgroundView = imageBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenProduct = favProducts[indexPath.row]
        performSegue(withIdentifier: Constants.Me.toSpecificProductInMe, sender: self)
    }
    
    
}
