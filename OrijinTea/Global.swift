//
//  Global.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 2/27/23.
//

import Foundation
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
    
    
    
}


