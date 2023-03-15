//
//  AdmSpecificProductViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/14/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdmSpecificProductViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    // Images
    @IBOutlet weak var prodImgView: UIImageView!
    // TextView
    @IBOutlet weak var descTxtView: UITextView!
    // TextField
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var prodYearTxt: UITextField!
    @IBOutlet weak var prodTagTxt: UITextField!
    @IBOutlet weak var prodCategoryTxt: UITextField!
    @IBOutlet weak var prodPlaceTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var unitTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var drinkPriceTxt: UITextField!
    // Switch
    @IBOutlet weak var addToMenuSwitch: UISwitch!
    // Button
    @IBOutlet weak var createBtnTxt: UIButton!
    // Searchbar
    @IBOutlet weak var searchBar: UISearchBar!
    // TableView
    @IBOutlet weak var searchTbView: UITableView!
    // View
    @IBOutlet weak var searchView: UIView!
    // ViewHeight
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    
    
    // Var from incomming segues
    var chosenProduct: Product? = nil
    // Var to store menuItem
    var menuItem: MenuItem? = nil
    
    // Mode (create, edit, ) --> For incomming segue
    var curMode: Global.Mode = .create
    
    // Search View transformation constants
    var close = CGFloat(0)
    var open = CGFloat(589.33)
    
    // Var for search view and its selection
    var choiceList = [String]()
    var curTextFieldPicked = ""
    var historyTxt = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSearchView(true)
        loadProductView()
        searchTbView.delegate = self
        searchTbView.dataSource = self
        prodCategoryTxt.delegate = self
        unitTxt.delegate = self
        
    }
    
    func loadProductView(){
        setSelectables()
        switch curMode{
        case .create:
            print("Currently Creating a product!")
        case .edit:
            getMenuItem { [self] in
                titleLabel.text = "Edit Product"
                productNameTxt.text = chosenProduct?.productName
                prodImgView.image = UIImage(named: (chosenProduct?.productPic) ?? "Tea Icon")
                descTxtView.text = chosenProduct?.description
                prodYearTxt.text = chosenProduct?.productionYear
                prodCategoryTxt.text = chosenProduct?.categoryName
                prodTagTxt.text = chosenProduct?.productTag
                prodPlaceTxt.text = chosenProduct?.productionPlace
                priceTxt.text = String((chosenProduct?.price)!)
                unitTxt.text = chosenProduct?.unit
                amountTxt.text = String((menuItem?.amount)!)
                drinkPriceTxt.text = String((menuItem?.price)!)
                createBtnTxt.titleLabel?.text = "Save Changes"
            }
        }
    }
    
    // MARK: - Helper methods
    func setSelectables(){
        prodCategoryTxt.tag = 0
        unitTxt.tag = 0
    }
    
    func setTxtFieldTxt(_ text: String, _ empty: Bool = false){
        if curTextFieldPicked == "prodCategoryTxt"{
            if empty{
                prodCategoryTxt.text = historyTxt
            }
            else{
                prodCategoryTxt.text = text
            }
            prodCategoryTxt.resignFirstResponder()
        }
        else if curTextFieldPicked == "unitTxt"{
            if empty{
                unitTxt.text = historyTxt
            }
            else{
                unitTxt.text = text
            }
            unitTxt.resignFirstResponder()
        }
    }
    
    func hideSearchView(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.searchViewHeight.constant = self.close
                self.view.layoutIfNeeded()
            }
        }
        else{
            UIView.animate(withDuration: 0.15) {
                self.searchViewHeight.constant = self.open
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Database methods
    func getAllLabels(_ labelName: String){
        choiceList.removeAll()
        let docRef = db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.labels)
        docRef.getDocument { docSnap, error in
            if let e = error{
                print("Error while retreiving labels \(e)")
            }
            else{
                let labelData = docSnap!.data()
                self.choiceList = labelData![labelName] as! [String]
                print("1: \(self.choiceList)")
                DispatchQueue.main.async {
                    self.searchTbView.reloadData()
                }
            }
        }
    }
    
    
    func getMenuItem(_ completion: @escaping () -> Void){
        let docRef = db.collection(Constants.FStoreCollection.menu).document((chosenProduct?.productTag)!)
        docRef.getDocument { docSnap, error in
            if let e = error{
                print("Error retreiving menu item in AdmSpecificProductViewController: \(e)")
            }
            else{
                let menuItemData = docSnap!.data()
                do{
                    let dat = try JSONSerialization.data(withJSONObject: menuItemData!)
                    let menuItem = try JSONDecoder().decode(MenuItem.self, from: dat)
                    self.menuItem = menuItem
                    completion()
                    // Set trigger
                    self.addToMenuSwitch.isOn = true
                }
                catch let error{
                    print("Error Creating Menu object \(error)")
                }
            }
        }
    }
    
    
    // MARK: - Button handlers
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.backToInventory, sender: self)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
    }
    
    @IBAction func createPdBtn(_ sender: UIButton) {
    }
    
    @IBAction func hideBtn(_ sender: UIButton) {
        hideSearchView(true)
        setTxtFieldTxt(" ", true)
    }
    

}

extension AdmSpecificProductViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.selectionSearchCell, for: indexPath)
        print(choiceList[indexPath.row])
        cell.textLabel?.text = choiceList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setTxtFieldTxt(choiceList[indexPath.row])
        hideSearchView(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        historyTxt = textField.text ?? " "
        switch textField.tag{
        case 0: // Product Category Text
            hideSearchView(false)
            curTextFieldPicked = "prodCategoryTxt"
            getAllLabels("categories")
        case 1: // Unit Text
            hideSearchView(false)
            curTextFieldPicked = "unitTxt"
            getAllLabels("labels")
        default:
            print("unknown txt")
        }
    }
    
    
}
