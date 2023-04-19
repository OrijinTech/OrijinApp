//
//  ProductsViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/1/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ProductsViewController: UIViewController {

    let db = Firestore.firestore()
    var titleTxt = ""
    var productsTypes = [String]()
    var filteredData = [String]()
    
    // Segue Variables
    var segueTitleTxt = ""
    var segueCollectionTxt = ""
    
    // Outlets
    @IBOutlet weak var headerTitleTxt: UILabel!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var productTbView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitleTxt.text = titleTxt
        loadProducts(titleTxt)
        productTbView.delegate = self
        productTbView.dataSource = self
        productTbView.rowHeight = 100
        searchBarOutlet.delegate = self
    }
    
    
    func loadProducts(_ productType: String){
        let docRef = db.collection(Constants.FStoreCollection.product).document(productType)
        docRef.getDocument { docSnap, error in
            if let e = error{
                print("Error loading product types! \(e)")
            }
            if let fieldValue = docSnap!.data()?["categories"] as? Array<String> {
                self.productsTypes = fieldValue.map { $0.capitalized }
                self.filteredData = self.productsTypes
            }
            self.productTbView.reloadData()
        }
    }
    
    
    // MARK: - Button
    @IBAction func backBtn(_ sender: UIButton) {
        if Global.menuMode{
            performSegue(withIdentifier: Constants.Shop.menuToTeashop, sender: self)
        }
        else{
            performSegue(withIdentifier: Constants.Shop.toProductOverview, sender: self)
        }
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productType", for: indexPath)
        if #available(iOS 15.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = Global.textLimiter(filteredData[indexPath.row], 6)
            config.textProperties.numberOfLines = 0
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = Global.textLimiter(filteredData[indexPath.row], 6)
            cell.textLabel?.numberOfLines = 0
        }
        let imageBackground = CustomBackgroundView()
        imageBackground.setImg("Default Cell Img")
        cell.backgroundView = imageBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueTitleTxt = filteredData[indexPath.row]
        performSegue(withIdentifier: Constants.Shop.generalTypeToTypeProducts, sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            filteredData = productsTypes
        }
        else{
            filteredData = productsTypes.filter { (item:String) in
                item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        self.productTbView.reloadData()
    }
    
    // Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Shop.generalTypeToTypeProducts{
            let destinationVC = segue.destination as? ProductListViewController
            destinationVC?.titleText = self.segueTitleTxt
            destinationVC?.subCollectionName = self.segueTitleTxt
            destinationVC?.productType = self.titleTxt
        }
    }
    
}
