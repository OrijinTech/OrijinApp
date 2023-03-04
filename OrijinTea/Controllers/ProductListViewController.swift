//
//  ProductListViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ProductListViewController: UIViewController {

    let db = Firestore.firestore()
    var prodList = [Product]()
    var filteredProdList = [Product]()
    
    // Variables from incomming segues
    var titleText = ""
    var productType = ""
    var subCollectionName = ""
    
    // Variables for outgoing segue
    var productObj: Product = Product()
    
    
    // Outlets
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTxt.text = titleText
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productSearchBar.delegate = self
        loadProducts(productType)
    }
    
        func loadProducts(_ productType: String){
            let collRef = db.collection(Constants.FStoreCollection.product).document(productType).collection(String(subCollectionName.lowercased()))
            collRef.getDocuments { tea, error in
                if let e = error{
                    print("Error retreiving specific list of tea. \(e)")
                }
                else{
                    if let teaProducts = tea?.documents{
                        for teaProduct in teaProducts{
                            let teaData = teaProduct.data()
                            do {
                                let dat = try JSONSerialization.data(withJSONObject: teaData)
                                let prodObj = try JSONDecoder().decode(Product.self, from: dat)
                                self.prodList.append(prodObj)
                                // print("Object created: \(prodObj.productName ?? "Default")")
                            } catch let error {
                                print("Error decoding object: \(error.localizedDescription)")
                            }
                        }
                        self.filteredProdList = self.prodList
                    }
                }
                self.productCollectionView.reloadData()
            }
        }

    
    
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Shop.typeProductsToGeneralType, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Shop.typeProductsToGeneralType{
            let destinationVC = segue.destination as? ProductsViewController
            destinationVC?.titleTxt = self.productType
        }
        else if segue.identifier == Constants.Shop.toSpecificProduct{
            let destinationVC = segue.destination as? SpecificProductViewController
            destinationVC?.chosenProduct = productObj
            destinationVC?.titleText = titleText
            destinationVC?.productType = productType
            destinationVC?.subCollectionName = subCollectionName
        }
        
    }
    
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProdList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.prodTypeCell, for: indexPath) as! ProductTypeViewCell
        cell.prodImg.image = UIImage(named: prodList[indexPath.row].categoryPic ?? "Tea Icon")
        cell.prodCategory.text = prodList[indexPath.row].productName
        
        // Cell Decoration
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productObj = filteredProdList[indexPath.row]
        performSegue(withIdentifier: Constants.Shop.toSpecificProduct, sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            filteredProdList = prodList
        }
        else{
            filteredProdList = prodList.filter { $0.productName!.lowercased().contains(searchText.lowercased()) }
        }
        self.productCollectionView.reloadData()
    }
    
}

