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
import SDWebImage
import FirebaseStorage

class AdmSpecificProductViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    // Images
    @IBOutlet weak var prodImgView: UIImageView!
    // TextView
    @IBOutlet weak var descTxtView: UITextView!
    // TextField
    @IBOutlet weak var prodClass: UITextField!
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
    // Image Picker
    let imagePicker = UIImagePickerController()
    
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
        prodClass.delegate = self
        imagePicker.delegate = self
    }
    
    func loadProductView(){
        setSelectables()
        switch curMode{
        case .create:
            print("Currently Creating a product!")
        case .edit:
            titleLabel.text = "Edit Product"
            createBtnTxt.titleLabel?.text = "Save Changes"
            // Prepare product info
            prodClass.text = chosenProduct?.productClass
            productNameTxt.text = chosenProduct?.productName
            prodImgView.image = UIImage(named: (chosenProduct?.productPic) ?? "Tea Icon")
            descTxtView.text = chosenProduct?.description
            prodYearTxt.text = chosenProduct?.productionYear
            prodCategoryTxt.text = chosenProduct?.categoryName
            prodTagTxt.text = chosenProduct?.productTag
            prodPlaceTxt.text = chosenProduct?.productionPlace
            priceTxt.text = String((chosenProduct?.price)!)
            unitTxt.text = chosenProduct?.unit
            // Get menu item
            getMenuItem { [self] in
                amountTxt.text = String((menuItem?.amount)!)
                drinkPriceTxt.text = String((menuItem?.price)!)
            }
        }
    }
    
    // MARK: - Helper methods
    func setSelectables(){
        prodCategoryTxt.tag = 0
        unitTxt.tag = 1
        prodClass.tag = 2
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
        else if curTextFieldPicked == "prodClass"{
            if empty{
                prodClass.text = historyTxt
            }
            else{
                prodClass.text = text
            }
            prodClass.resignFirstResponder()
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
        if labelName == "categories" && prodClass.text != ""{
            let docRef = db.collection(Constants.FStoreCollection.product).document(prodClass.text!)
            docRef.getDocument { docSnap, error in
                if let e = error{
                    print("Error while retreiving labels \(e)")
                }
                else{
                    let labelData = docSnap!.data()
                    self.choiceList = labelData![labelName] as! [String]
                    DispatchQueue.main.async {
                        self.searchTbView.reloadData()
                    }
                }
            }
        }
        else if labelName == "units" || labelName == "prodClass"{
            let docRef = db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.labels)
            docRef.getDocument { docSnap, error in
                if let e = error{
                    print("Error while retreiving labels \(e)")
                }
                else{
                    let labelData = docSnap!.data()
                    self.choiceList = labelData![labelName] as! [String]
                    DispatchQueue.main.async {
                        self.searchTbView.reloadData()
                    }
                    print("1: \(self.choiceList)")
                }
            }
        }
        else{
            choiceList.removeAll()
            DispatchQueue.main.async {
                self.searchTbView.reloadData()
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
                if let document = docSnap, document.exists{
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
    }
    

    func createProduct(){
        var created = false
        if allFieldsFilled(){
            let colRef = db.collection(Constants.FStoreCollection.product).document(prodClass.text!).collection(prodCategoryTxt.text!)
            let product = Product(productName: productNameTxt.text, categoryName: prodCategoryTxt.text!, productionPlace: prodPlaceTxt.text!, productionYear: prodYearTxt.text!, description: descTxtView.text!, productTag: prodTagTxt.text!, productClass: prodClass.text!, unit: unitTxt.text!, price: Int(priceTxt.text!))
            do{
                try colRef.document(prodTagTxt.text!).setData(from: product)
                created = true
            }
            catch let error{
                print("Error writing city to Firestore: \(error)")
            }
        }
        // if the add to menu is checked then add it to menu too
        if created && addToMenuSwitch.isOn && amountTxt.text != "" && drinkPriceTxt.text != ""{
            let colRef = db.collection(Constants.FStoreCollection.menu)
            let menuItem = MenuItem(amount: Int(amountTxt.text!)!, name: productNameTxt.text!, price: Int(drinkPriceTxt.text!)!, tag: prodTagTxt.text!)
            do{
                try colRef.document(prodTagTxt.text!).setData(from: menuItem)
            }
            catch let error{
                print("Error writing city to Firestore: \(error)")
            }
        }
        // if the product is created but the menu button is not on, remove the menu item
        else if created && !addToMenuSwitch.isOn{
            let docRef = db.collection(Constants.FStoreCollection.menu).document(prodTagTxt.text!)
            docRef.delete() { error in
                if let e = error{
                    print("Erorr deleting menu item. \(e.localizedDescription)")
                }
                else{
                    print("Menu Removed")
                }
            }
        }
        if created{
            performSegue(withIdentifier: Constants.Admin.backToInventory, sender: self)
        }
    }
    
    
    func allFieldsFilled() -> Bool{
        if prodClass.text != "" && productNameTxt.text != "" && prodYearTxt.text != "" && prodTagTxt.text != "" && prodCategoryTxt.text != "" && prodPlaceTxt.text != "" && priceTxt.text != "" && unitTxt.text != ""{
            return true
        }
        else{
            return false
        }
    }
    
    
    // MARK: - Button handlers
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.backToInventory, sender: self)
    }
    
    // Add product picture
    @IBAction func addBtn(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPdBtn(_ sender: UIButton) {
        createProduct() // same as saving a product
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
        print(textField.tag)
        switch textField.tag{
        case 0: // Product Category Text
            hideSearchView(false)
            curTextFieldPicked = "prodCategoryTxt"
            getAllLabels("categories")
        case 1: // Unit Text
            hideSearchView(false)
            curTextFieldPicked = "unitTxt"
            getAllLabels("units")
        case 2: // Product Class
            print("Product Class")
            hideSearchView(false)
            curTextFieldPicked = "prodClass"
            getAllLabels("prodClass")
        default:
            print("unknown txt")
        }
    }
}

extension AdmSpecificProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected image from the info dictionary.
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        prodImgView.image = image
        prodImgView.clipsToBounds = true
        // Dismiss the image picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
}
