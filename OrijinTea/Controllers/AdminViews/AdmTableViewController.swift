//
//  AdmTableViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/10/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdmTableViewController: UIViewController {
    
    let db = Firestore.firestore()
    var tableList = [Tables]()
    
    // outlets
    @IBOutlet weak var tableCollection: UICollectionView!
    
    // Outgoing segue var
    var chosenTable: Tables?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableCollection.delegate = self
        tableCollection.dataSource = self
        getAllTables()
    }
    
    
    func getAllTables(){
        tableList.removeAll()
        let colRef = db.collection(Constants.FStoreCollection.tables)
        colRef.getDocuments { qSnap, error in
            if let e = error{
                print("Error Loading Tables \(e)")
            }
            else{
                if let qSnap = qSnap?.documents{
                    for curTable in qSnap{
                        let tableData = curTable.data()
                        do{
                            let dat = try JSONSerialization.data(withJSONObject: tableData)
                            let tableObj = try JSONDecoder().decode(Tables.self, from: dat)
                            self.tableList.append(tableObj)
                        }
                        catch let error{
                            print("Error creating table object \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableCollection.reloadData()
                    }
                }
            }
        }
    }

    
    // buttons
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Admin.admTablesToMain, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Admin.admToSpecificTable{
            let destinationVC = segue.destination as? AdmSpecificTableViewController
            destinationVC?.chosenTable = self.chosenTable
        }
    }
    

}

extension AdmTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tableCollection.dequeueReusableCell(withReuseIdentifier: Constants.admTableCell, for: indexPath) as! ProductTypeViewCell
        cell.prodImg.image = UIImage(named: "Tea Icon")
        cell.prodCategory.text = tableList[indexPath.row].name
        
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
        chosenTable = tableList[indexPath.row]
        performSegue(withIdentifier: Constants.Admin.admToSpecificTable, sender: self)
    }
    
    
}
