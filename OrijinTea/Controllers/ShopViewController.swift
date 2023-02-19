//
//  ShopViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/8/23.
//


import UIKit


class ShopViewController: UIViewController{
    
    @IBOutlet weak var shopCatCollectionView: UICollectionView!
    @IBOutlet var shopView: UIView!
    
    var catList = [ProductData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopCatCollectionView.delegate = self
        fillData()
        
    }
    
    
    private func fillData(){
        let teaCat = ProductData(categoryPic: "Tea Icon", categoryName: "Tea")
        catList.append(teaCat)
        
        let ceramicCat = ProductData(categoryPic: "Ceramics Icon", categoryName: "Ceramics")
        catList.append(ceramicCat)
        
    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.shopToMain, sender: self)
        
    }
    
    
}


extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = shopCatCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.prodTypeCell, for: indexPath) as! ProductTypeViewCell
        cell.prodImg.image = UIImage(named: catList[indexPath.row].categoryPic)
        cell.prodCategory.text = catList[indexPath.row].categoryName
        
        // Cell Decoration
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = (collectionView.frame.size.width-30)/3
//        return CGSize(width: size, height: size)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You have clicked on \(catList[indexPath.row].categoryName)")
    }
    
}


