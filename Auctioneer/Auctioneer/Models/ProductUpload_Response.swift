//
//  ProductUpload_Response.swift
//  Auctioneer
//
//  Created by Shion on 12/1/22.
//

import FirebaseFirestore
import Firebase

//#Mark:- Users model
struct ProductUpload_Response {

    var userKey : String
    var imageUrl : String


    var dictionary : [String:Any] {
        return [
                "user_key": userKey  ?? "",
                "image_url": imageUrl  ?? ""
        ]
    }

   init(snapshot: QueryDocumentSnapshot) {
        var snapshotValue = snapshot.data()
        userKey = snapshotValue["user_key"] as! String
        imageUrl = snapshotValue["image_url"] as! String
    }
}
