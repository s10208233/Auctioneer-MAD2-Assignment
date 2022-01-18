//
//  HomeFeedViewController.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import FirebaseDatabase
import UIKit

class HomeFeedViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    func retrieveData()->[String:User]{
        var returndict:[String:User] = [:]
        let ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value){ (snapshot) in
            let users = snapshot.value as! [String:Dictionary<String, Any>]
            users.forEach{ pairs in
                returndict.updateValue(User(Username: pairs.value["Username"] as! String, Password:pairs.value["Password"] as! String), forKey: pairs.key)
            }
        }
        return returndict
    }
}
