//
//  AdmSpecificTableViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/10/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class AdmSpecificTableViewController: UIViewController {
    
    let db = Firestore.firestore()

    // Outlets
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var tableStatusTxt: UILabel!
    @IBOutlet weak var tablesTbView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    
    
    // Distance constants
    let open = CGFloat(664)
    let close = CGFloat(0)
    
    
    // Search bar filtered items
    var allProductList = [MenuItem]()
    var filteredProducts = [MenuItem]()
    var chosenProduct: MenuItem?
    var chosenProductList = [MenuItem]()
    var selectedProducts = [MenuItem]()
    
    // Segue From Previous Screen
    var chosenTable: Tables?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        // tableview tags for switch cases
        tablesTbView.tag = 0
        searchTableView.tag = 1
        // delegates and datasources
        tablesTbView.delegate = self
        tablesTbView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        getAllMenuItems()
        loadTableData()
        popUpView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will dissappear")
        saveTableDataToDB()
    }
    
    func prepareView(){
        titleTxt.text = chosenTable?.name
        hideSearchView(true)
        tableStatusTxt.text = emptyTxt()
    }
    
    func emptyTxt() -> String{
        if chosenTable?.isEmpty == true{
            return "Empty"
        }
        else if chosenTable?.isEmpty == false{
            return "Full"
        }
        else{
            return "Unknown"
        }
    }
    
    
    func hideSearchView(_ hide: Bool){
        if hide{
            UIView.animate(withDuration: 0.15) {
                self.searchViewHeight.constant = self.close
                self.tablesTbView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
        else{
            UIView.animate(withDuration: 0.15) {
                self.searchViewHeight.constant = self.open
                self.searchTableView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func getAllMenuItems(){
        filteredProducts.removeAll()
        allProductList.removeAll()
        let colRef = db.collection(Constants.FStoreCollection.menu)
        colRef.getDocuments { qSnap, error in
            if let e = error{
                print("Error Loading Tables \(e)")
            }
            else{
                if let qSnap = qSnap?.documents{
                    for menuItemDoc in qSnap{
                        let menuItemData = menuItemDoc.data()
                        do{
                            let dat = try JSONSerialization.data(withJSONObject: menuItemData)
                            let menuItem = try JSONDecoder().decode(MenuItem.self, from: dat)
                            self.allProductList.append(menuItem)
                        }
                        catch let error{
                            print("Error Creating Menu object \(error)")
                        }
                    }
                    self.filteredProducts = self.allProductList
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func saveTableDataToDB(){
        let colRef = db.collection(Constants.FStoreCollection.tables)
        let dictionaries = chosenProductList.map { $0.toDictionary() }
        colRef.document(chosenTable!.tableID).updateData([
            "curItems": dictionaries
        ])
    }
    
    func loadTableData(){ // This is how you take a dictionary from Firestore and convert to a list of objects
        let docRef = db.collection(Constants.FStoreCollection.tables).document(chosenTable!.tableID)
        docRef.getDocument { document, error in
            if let e = error{
                print("Error loading table data \(e)")
            }
            else{
                if let document = document, document.exists {
                    let menuData = document.data()
                    let dictionary = menuData![Constants.FStoreField.Table.curItems] as! [[String: Any]]
                    if dictionary.count > 0{
                        for items in dictionary{
                            let menuItem = MenuItem(amount: items["amount"] as? Int ?? 1,
                                                    itemCount: items["itemCount"] as? Int ?? 1,
                                                    name: items["name"] as! String,
                                                    price: items["price"] as? Int ?? 0,
                                                    tag: items["tag"] as! String)
                            self.chosenProductList.append(menuItem)
                        }
                        DispatchQueue.main.async {
                            self.tablesTbView.reloadData()
                        }
                    }
                }
                else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
    func updateTableOccupancy(_ occupied: Bool){ // true = set to empty, false = set to full
        let colRef = db.collection(Constants.FStoreCollection.tables)
        colRef.document(chosenTable!.tableID).updateData([
            Constants.FStoreField.Table.tableEmpty: occupied
        ])
    }
    
    
    func addToPayHistory(){
        var orderID = 0
        getOrderID { ordID in
            orderID = ordID!
            let order = Order(items: self.chosenProductList, payDay: self.getCurDay(), payTime: self.getCurTime(), orderID: orderID)
            let docRef = self.db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.statics).collection(Constants.FStoreCollection.orderHistory).document(String(order.orderID))
            do {
                try docRef.setData(from: order)
                self.chosenProductList.removeAll()
                self.selectedProducts.removeAll()
                DispatchQueue.main.async {
                    self.tablesTbView.reloadData()
                }
            } catch let error {
                print("Error writing Order to Firestore: \(error)")
            }
        }
        updateOrderID()
    }
    
    
    func getCurTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func getCurDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    
    // Retreive current booking ID for use
    func getOrderID(completion: @escaping (Int?) -> Void){
        var docuID = 0
        let docRef = db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.statics)
        docRef.getDocument { qsnap, error in
            if let e = error{
                print("Error: Retreiving booking ID: \(e)")
            }
            else{
                if let doc = qsnap, doc.exists{
                    docuID = (doc.data()?[Constants.FStoreField.Statics.orderID] as? Int)!
                    completion(docuID) // throws the docuID to the completion statements
                }
                else{
                    completion(nil)
                    print("doc does not exist while getOrderID")
                }
            }
        }
    }
    
    
    // Update booking ID (after user books a table, this is a global value shared among users)
    func updateOrderID(){
        getOrderID { int in
            let finalID = int! + 1
            let docRef = self.db.collection(Constants.FStoreCollection.adminStats).document(Constants.FStoreDocument.statics)
            docRef.updateData([Constants.FStoreField.Statics.orderID : finalID]){ error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully")
                }
            }
        }
    }
    
    
    func markOccupied(){
        if (chosenTable!.isEmpty){
            chosenTable?.isEmpty = false
            updateTableOccupancy(false)
            tableStatusTxt.text = "Full"
        }
        else{
            chosenTable?.isEmpty = true
            updateTableOccupancy(true)
            tableStatusTxt.text = "Empty"
        }
    }
    
    
    
    
    // MARK: - Buttons
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admBackToTables, sender: self)
    }
    
    @IBAction func deleteAll(_ sender: UIButton) {
        chosenProductList.removeAll()
        getAllMenuItems() // reload menu items from Firestore to reset itemCount
        DispatchQueue.main.async {
            self.tablesTbView.reloadData()
        }
    }
    
    @IBAction func deleteItemsBtn(_ sender: UIButton) {
        for prod in selectedProducts{
            chosenProductList.removeAll(where: {$0.tag == prod.tag})
        }
        selectedProducts.removeAll()
        getAllMenuItems()
        DispatchQueue.main.async {
            self.tablesTbView.reloadData()
        }
    }
    
    @IBAction func addItemBtn(_ sender: UIButton) {
        hideSearchView(false)
    }
    
    @IBAction func paidBtn(_ sender: UIButton) {
        if !chosenProductList.isEmpty{
            addToPayHistory()
            markOccupied()
            popUpView.isHidden = false
        }
        
    }
    
    @IBAction func markOccBtn(_ sender: UIButton) {
        markOccupied()
    }
    
    @IBAction func hideBtn(_ sender: UIButton) {
        hideSearchView(true)
    }
    
    @IBAction func popupBackBtn(_ sender: UIButton) {
        popUpView.isHidden = true
    }
    
}


extension AdmSpecificTableViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag{
        case 0:
            return chosenProductList.count
        case 1:
            return filteredProducts.count
        default:
            print("Error: Table view unknown.")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellNum = ""
        if tableView.tag == 0{
            cellNum = Constants.tableCell
        }
        else {
            cellNum = Constants.searchedCell
        }
        // create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNum, for: indexPath)
        
        switch tableView.tag{
        case 0: // For currently selected products for customers
            // prepare chosenProductList
            // Labels by code
            let detailLabel = UILabel()
            detailLabel.text = String(chosenProductList[indexPath.row].itemCount)
            detailLabel.sizeToFit()
            cell.accessoryView = detailLabel
            cell.textLabel?.text = chosenProductList[indexPath.row].name
            
        case 1: // For Filtered products
            // preapare fileredProducts list
            cell.textLabel?.text = filteredProducts[indexPath.row].name
        default:
            print("Error: Table view unknown.")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch tableView.tag{
        case 0: // For currently selected products for customers
            // If item already in selected products list
            if(selectedProducts.contains(where: { $0.tag == chosenProductList[indexPath.row].tag})){
                let detailLabel = UILabel()
                detailLabel.text = String(chosenProductList[indexPath.row].itemCount)
                detailLabel.sizeToFit()
                cell?.accessoryView = detailLabel
                cell?.textLabel?.text = chosenProductList[indexPath.row].name
                cell?.accessoryType = .none
                selectedProducts.removeAll(where: {$0.tag == chosenProductList[indexPath.row].tag})
            }
            else{ // if item not in the selected product
                cell?.accessoryView = nil
                let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
                cell?.accessoryView = checkmarkView
                cell?.textLabel?.text = "Price: \(chosenProductList[indexPath.row].price * chosenProductList[indexPath.row].itemCount)   |   Amount(per serving): \(chosenProductList[indexPath.row].amount)g"
                selectedProducts.append(chosenProductList[indexPath.row])
            }
        case 1: // For Filtered products
            chosenProduct = filteredProducts[indexPath.row]
            if chosenProductList.contains(where: {$0.tag == chosenProduct?.tag}){
                chosenProductList[indexPath.row].itemCount += 1
            }
            else {
                chosenProductList.append(chosenProduct!)
            }
            tablesTbView.reloadData()
            hideSearchView(true)
        default:
            print("Error: Table view unknown.")
        }
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            filteredProducts = allProductList
        }
        else{
            filteredProducts = allProductList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        self.searchTableView.reloadData()
    }
    
    
}
