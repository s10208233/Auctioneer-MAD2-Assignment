//
//  UserDAL.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import FirebaseDatabase

class UserDAL {
    private let ref = Database.database().reference()
    
    public func CreateNewUser(newuser:User){
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            let
        }
    }
}
