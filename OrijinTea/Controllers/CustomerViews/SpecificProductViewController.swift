//
//  SpecificProductViewController.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


class SpecificProductViewController: UIViewController {
    
    @IBOutlet weak var screenTitleTxt: UILabel!
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var productTitleTxt: UILabel!
    @IBOutlet weak var aboutTxt: UITextView!
    @IBOutlet weak var prodYearLabel: UITextField!
    @IBOutlet weak var prodCategoryLabel: UITextField!
    @IBOutlet weak var prodPlaceLabel: UITextField!
    @IBOutlet weak var prodTagLabel: UITextField!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var personalNoteTitle: UILabel!
    @IBOutlet weak var noteTxtView: UITextView!
    @IBOutlet weak var personalNotes: UITextView!
    
    
    // database references
    let db = Firestore.firestore()
    
    
    let placeholderTXT = "About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About Tea About"
    var currentLiked = false // current like button status
    
    // Variables for outgoing segue
    var titleText = ""
    var productType = ""
    var subCollectionName = "" // This is right now in uppercase first letter, if you want to use this to retreive database data, then check for correct casing
    
    // Variable from incomming segue
    var chosenProduct: Product = Product()
    var incomingSegue: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProductPage(chosenProduct)
        setLikeButtonStatus(containsLikedProduct())
        productViewMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("updating like list")
        updateUserLikeList()
        updateNotes()
    }
    
    func setUpProductPage(_ product: Product){
        screenTitleTxt.text = product.productName
        topImg.image = UIImage(named: product.categoryPic ?? "Tea Icon")
        productTitleTxt.text = product.productName
        aboutTxt.text = product.description
        prodYearLabel.text = product.productionYear
        prodCategoryLabel.text = product.categoryName
        prodPlaceLabel.text = product.productionPlace
        prodTagLabel.text = product.productTag
    }
    
    
    // WARNING: Currently not deleting user notes when the product is not liked.
    func updateUserLikeList(){
        if currentLiked && !containsLikedProduct(){ // button is liked, but list does not contain this product
            Global.favorites.append(chosenProduct)
            Global.favoritesTags.append(chosenProduct.productTag!)
            // update database
            let userDocRef = db.collection(Constants.FStoreCollection.users).document(Global.User.email)
            let productDocRef = db.collection(Constants.FStoreCollection.product).document(chosenProduct.productClass!).collection((chosenProduct.categoryName?.lowercased())!).document(chosenProduct.productTag!)
            Global.User.favoriteProducs.append(productDocRef)
            userDocRef.updateData([Constants.FStoreField.Users.favoriteProducts: Global.User.favoriteProducs]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        else if !currentLiked && containsLikedProduct(){ // button is not liked, and list contains the product
            // Removing from Global lists
            Global.favorites.removeAll{ $0.productTag == chosenProduct.productTag }
            Global.favoritesTags = Global.favoritesTags.filter{$0 != chosenProduct.productTag}
            // Update database
            let userDocRef = db.collection(Constants.FStoreCollection.users).document(Global.User.email)
            let productDocRef = db.collection(Constants.FStoreCollection.product).document(chosenProduct.productClass!).collection((chosenProduct.categoryName?.lowercased())!).document(chosenProduct.productTag!)
            Global.User.favoriteProducs.removeAll{$0.documentID == productDocRef.documentID }
            userDocRef.updateData([Constants.FStoreField.Users.favoriteProducts: Global.User.favoriteProducs])
        }
        Global.getFavoriteProducts {
            Global.convertFavProdctToObj()
        }
    }
    
    func productViewMode(){
        if incomingSegue == Constants.Shop.toSpecificProduct{
            personalNoteTitle.isHidden = true
            noteTxtView.isHidden = true
        }
        else if incomingSegue == Constants.Me.toSpecificProductInMe{
            personalNoteTitle.isHidden = false
            noteTxtView.isHidden = false
            noteTxtView.layer.borderWidth = 1
            noteTxtView.layer.borderColor = UIColor.black.cgColor
            let docRef = db.collection(Constants.FStoreCollection.users).document(Global.User.email).collection(Constants.FStoreCollection.notes).document(chosenProduct.productTag!)
            docRef.getDocument { documentSnapshot, error in
                if let document = documentSnapshot, document.exists {
                    let data = document.data()
                    self.noteTxtView.text = (data![Constants.FStoreField.Users.note] as! String)
                    self.viewDidLayoutSubviews()
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    func updateNotes(){
        if incomingSegue == Constants.Me.toSpecificProductInMe{
            let docRef = db.collection(Constants.FStoreCollection.users).document(Global.User.email).collection(Constants.FStoreCollection.notes).document(chosenProduct.productTag!)
            docRef.updateData([Constants.FStoreField.Users.note : noteTxtView.text ?? "Enter personal notes for this product."])
        }
    }
    
    func setLikeButtonStatus(_ liked: Bool){
        if liked{
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            currentLiked = true
        }
        else{
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            currentLiked = false
        }
    }
    
    func containsLikedProduct() -> Bool{
        if Global.favoritesTags.contains(chosenProduct.productTag!){
            return true
        }
        else{
            return false
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        if incomingSegue == Constants.Me.toSpecificProductInMe{
            performSegue(withIdentifier: Constants.Shop.toMyTeaBook, sender: self)
        }
        else if incomingSegue == Constants.Shop.toSpecificProduct{
            performSegue(withIdentifier: Constants.Shop.specificToProductList, sender: self)
        }
        
    }
    
    @IBAction func likeTriggered(_ sender: UIButton) {
        // if current product is inside the user's favorite product list, then set heart button to
        if currentLiked{ // this product is currently inside like list and we press the button
            setLikeButtonStatus(false)
            // remove from like list
            
        }
        else{ // the product is currently not in the like list we press the button
            setLikeButtonStatus(true)
            // add it to the like list
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Shop.specificToProductList{
            let destinationVC = segue.destination as? ProductListViewController
            destinationVC?.titleText = titleText
            destinationVC?.productType = productType
            destinationVC?.subCollectionName = subCollectionName
        }
    }
    
}

