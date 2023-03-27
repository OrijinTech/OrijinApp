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
    
    // Enum for Admin Product Editing mode
    enum Mode: String {
        case edit = "e"
        case create = "c"
    }
    
    // For USERS
    static var products: [String] = []
    static var favorites: [Product] = [] // This is for user's unique list of favorite productss
    static var favoritesTags: [String] = [] // This is the user's unique list of favorite produts' tag
    
    // For ADMIN
    static var allProducts: [Product] = []
    
    
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
    
    static func calcTotalPrice(for menuList:[MenuItem]) -> Int{
        var totalPrice = 0
        for item in menuList{
            totalPrice = totalPrice + item.price
        }
        return totalPrice
    }
    
    // Turn Date() into seconds since 1970
    static func dateToSeconds(for date: Date) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    
    // Turn time and date string into Date object
    static func stringToDate(for date: String, for time: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: "\(date) \(time)")!
    }
    
    // Updates the status of each reservation.
    static func updateReservations(){
        let db = Firestore.firestore()
        let colRef = db.collection(Constants.FStoreCollection.reservations)
        colRef.getDocuments { qSnap, error in
            if let e = error{
                print("Error retreiving reservations in loading screen! \(e.localizedDescription)")
            }
            else{
                if let docSnap = qSnap?.documents{
                    for res in docSnap{
                        let resData = res.data()
                        do{
                            let dat = try JSONSerialization.data(withJSONObject: resData)
                            let reservation = try JSONDecoder().decode(Reservation.self, from: dat)
                            // Based on time, set the complete status
                            let curDate = Int(Date().timeIntervalSince1970)
                            let resDate = Global.dateToSeconds(for: Global.stringToDate(for: reservation.date, for: reservation.time))
                            if(resDate < curDate){
                                reservation.setCompleted()
                            }
                            do{
                                try db.collection(Constants.FStoreCollection.reservations).document(String(reservation.reservationID)).setData(from:reservation)
                            }
                            catch let error{
                                print("Error changing reservation status: \(error)")
                            }
                        }
                        catch let error{
                            print("Error creating table object \(error)")
                        }
                    }
                }
            }
        }
    }
    
    
}


