//
//  User_Response.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import FirebaseDatabase

struct User_Response {
    var Username:String
    var Password:String
    
    var dictionary:[String:Any] {
        return [
            "Username" : Username ?? "",
            "Password" : Password ?? ""
        ]
    }
    
//    init(snapshot:DataSnapshot) {
//        var snapshotValue = snapshot.value
//        Username = snapshotValue["Username"] as! String
//        Password = snapshotValue["Password"] as! String
//    }
}
