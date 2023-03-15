//
//  InventoryViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/14/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class InventoryViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var listOfCat1 = [String]()
    var filteredProducts = [Product]()
    var allProducts = [Product]()
    
    // Var for outgoing segue
    var chosenProduct: Product? = nil
    var curMode: Global.Mode = .create

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        getAllProducts()
    }
    
    
    // MARK: - database methods
    func getAllProducts(){ // Require further optimization to decrease read load
        filteredProducts.removeAll()
        allProducts.removeAll()
        if Global.products.isEmpty{ // if global list is empty, fetch the products
            let colRef = db.collection(Constants.FStoreCollection.product)
            colRef.getDocuments { qSnap, error in
                if let e = error{
                    print("Error Loading Tables \(e)")
                }
                else{
                    if let qSnap = qSnap?.documents{
                        for menuItemDoc in qSnap{ // For each main categories
                            let data = menuItemDoc.data()
                            let subCatList = data[Constants.FStoreField.Products.categories] as! [String]
                            for subCat in subCatList{ // For each sub category
                                let subColRef = menuItemDoc.reference.collection(subCat)
                                subColRef.getDocuments { productSnap, error in
                                    if let e = error{
                                        print("Error loading products form a subcategory! \(e.localizedDescription)")
                                    }
                                    else{
                                        if let prodSnap = productSnap?.documents{
                                            for prod in prodSnap{ // For each product,
                                                let productData = prod.data()
                                                do{
                                                    let dat = try JSONSerialization.data(withJSONObject: productData)
                                                    let productItem = try JSONDecoder().decode(Product.self, from: dat)
                                                    if !(productItem.productTag == nil) && !self.allProducts.contains(where: {$0.productTag == productItem.productTag}){
                                                        self.allProducts.append(productItem)
                                                    }
                                                }
                                                catch let error{
                                                    print("Error Creating Product object \(error)")
                                                }
                                            }
                                            Global.allProducts = self.allProducts
                                            self.filteredProducts = self.allProducts
                                            DispatchQueue.main.async {
                                                self.searchTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Admin.inventoryToCreatePd{
            let destinationVC = segue.destination as? AdmSpecificProductViewController
            destinationVC?.chosenProduct = chosenProduct
            destinationVC?.curMode = curMode
        }
    }
    
    
    
    
    // MARK: - button press
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.inventoryToAdmMain, sender: self)
    }
    
    @IBAction func addProductBtn(_ sender: UIButton) {
        curMode = .create
        performSegue(withIdentifier: Constants.Admin.inventoryToCreatePd, sender: self)
    }
    
}


extension InventoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.prodSearchCell, for: indexPath)
        let detailLabel = UILabel()
        detailLabel.text = filteredProducts[indexPath.row].productTag
        detailLabel.sizeToFit()
        cell.accessoryView = detailLabel
        cell.textLabel?.text = filteredProducts[indexPath.row].productName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenProduct = filteredProducts[indexPath.row]
        curMode = .edit
        performSegue(withIdentifier: Constants.Admin.inventoryToCreatePd, sender: self)
    }

    
    
    
    
}
