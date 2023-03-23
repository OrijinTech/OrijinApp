//
//  OccupancyViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/23/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class OccupancyViewController: UIViewController {

    
    @IBOutlet weak var occupancyTbView: UITableView!
    @IBOutlet weak var reloadBtnLayout: UIButton!
    
    
    let db = Firestore.firestore()
    var tables = [Tables]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        occupancyTbView.delegate = self
        occupancyTbView.dataSource = self
        loadTables()
    }
    

    func loadTables(){
        tables.removeAll()
        let colRef = db.collection(Constants.FStoreCollection.tables)
        colRef.getDocuments { qsnap, error in
            if let e = error{
                print("Error Loading Tables: In table occupancy. \(e)")
            }
            else{
                if let snapdocs = qsnap?.documents{
                    for curTable in snapdocs{
                        let tableData = curTable.data()
                        do{
                            let dat = try JSONSerialization.data(withJSONObject: tableData)
                            let tableObj = try JSONDecoder().decode(Tables.self, from: dat)
                            self.tables.append(tableObj)
                        }
                        catch let error{
                            print("Error creating table object \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.occupancyTbView.reloadData()
                    }
                }
            }
        }
    }
    
    // Buttons
    @IBAction func backBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.occupancyToBook, sender: self)
    }
    
    @IBAction func reloadBtn(_ sender: UIButton) {
        loadTables()
    }
    
}


extension OccupancyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.occupancyCell, for: indexPath)
        let image = UIImage(systemName: "circle.fill")?.withTintColor(tables[indexPath.row].isEmpty ? .green : .red, renderingMode: .alwaysOriginal)
        let statusView = UIImageView(image: image)
        statusView.sizeToFit()
        cell.accessoryView = statusView
        cell.textLabel?.text = "\(tables[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
