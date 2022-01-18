//
//  MainDAL.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import FirebaseDatabase

class MainDAL {
    init() {}
    public let ref = Database.database().reference()
    
    public func RetrieveProductDictionary()->[String:User] {
        var userdictionary:[String:User] = [:]
        ref.child("Users").observeSingleEvent(of: .value) {
            (snapshot) in
            let users = snapshot.value as? [String:Dictionary<String,Any>]

            users?.forEach{ pairs in
                print(pairs.value["Username"] as! String)
                let thisuser:User = User(Username: pairs.value["Username"] as! String, Password: pairs.value["Password"] as! String)
                userdictionary.updateValue(thisuser, forKey: pairs.key)
            }
        }
        return userdictionary
    }
}
