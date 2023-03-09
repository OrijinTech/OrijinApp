//
//  Global.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/27/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Global {
    
    struct User{
        static var id: String = ""
        static var firstName: String = ""
        static var lastName: String = ""
        static var email: String = ""
        static var teaPoints: Int = 0
        static var userName: String = ""
        static var favoriteProducs: [DocumentReference] = []
        static var userType: String = ""
    }
    
    static var products: [String] = []
    
    static var favorites: [Product] = [] // This is for user's unique list of favorite productss
    static var favoritesTags: [String] = [] // This is the user's unique list of favorite produts' tag
    
    
    
    // MARK: - GLOBAL FUNCTIONS
    static func textLimiter(_ inpTxt: String, _ numOfChars:Int) -> String{
        if inpTxt.count > 0{
            var changeTxt = inpTxt
            var idx = numOfChars
            var retTxt = ""
            if changeTxt.count > numOfChars{
                var charIdx = changeTxt.index(changeTxt.startIndex, offsetBy: idx)
                while changeTxt[charIdx] != " " && changeTxt.count > idx+1{
                    idx += 1
                    charIdx = changeTxt.index(changeTxt.startIndex, offsetBy: idx)
                }
                if(changeTxt[charIdx] == " "){
                    changeTxt.insert("\n", at: changeTxt.index(changeTxt.startIndex, offsetBy: idx))
                    retTxt = changeTxt
                    return retTxt
                }
                else{
                    return inpTxt
                }
                
            }
            else{
                return inpTxt
            }
        }
        return "Error in TextLimiter"
    }

    // Loading favorite products
    static func getFavoriteProducts(_ completion: @escaping () -> Void){
        print("Getting Favorite Products")
        let userRef = Firestore.firestore().collection(Constants.FStoreCollection.users).document(Global.User.email)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error retrieving user document: \(error)")
            } else {
                let data = snapshot?.data()
                Global.User.favoriteProducs = data?[Constants.FStoreField.Users.favoriteProducts] as? [DocumentReference] ?? []
                completion()
                print("User's products: \(Global.User.favoriteProducs)")
            }
        }
    }
    
    static func convertFavProdctToObj(){
        Global.favorites.removeAll()
        for docRef in Global.User.favoriteProducs{
            docRef.getDocument() { (document, error) in
                print(docRef.path)
                if let document = document, document.exists {
                    let docData = document.data()
                    do {
                        let dat = try JSONSerialization.data(withJSONObject: docData!)
                        let prodObj = try JSONDecoder().decode(Product.self, from: dat)
                        Global.favorites.append(prodObj)
                        Global.favoritesTags.append(prodObj.productTag!)
                        print(Global.favorites)
                    } catch let error {
                        print("Error decoding object: \(error.localizedDescription)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
}


