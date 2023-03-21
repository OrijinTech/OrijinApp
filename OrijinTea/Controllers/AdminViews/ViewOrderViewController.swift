//
//  PaymentHistoryViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/20/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewOrderViewController: UIViewController {
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderTbView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    // var for table view
    var itemList = [MenuItem]()
    
    // incomming segue
    var chosenOrder: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        orderTbView.delegate = self
        orderTbView.dataSource = self
    }
    
    
    func prepareView(){
        orderIDLabel.text = String((chosenOrder?.orderID)!)
        dateLabel.text = chosenOrder?.payDay
        itemList = chosenOrder!.items
        priceLabel.text = String(Global.calcTotalPrice(for: itemList))
    }

}


extension ViewOrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.orderItemCell, for: indexPath)
        let detailLabel = UILabel()
        detailLabel.text = String(itemList[indexPath.row].price)
        detailLabel.sizeToFit()
        cell.accessoryView = detailLabel
        cell.textLabel?.text = "\(itemList[indexPath.row].name)"
        return cell
    }
}
