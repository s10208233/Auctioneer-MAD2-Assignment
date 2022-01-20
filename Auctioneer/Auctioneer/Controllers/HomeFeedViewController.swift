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
    
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var returndict:[String:AuctionItem] = [:]
        let ref = Database.database().reference()
        ref.child("Products").observeSingleEvent(of: .value){ (snapshot) in
            let products = snapshot.value as! [String:Dictionary<String, Any>]
            products.forEach{ pairs in()
                returndict.updateValue(AuctionItem(productname: pairs.value["productname"] as! String, imageurl: pairs.value["imageurl"] as! String, openedby: pairs.value["openby"] as! String, opendate: formatter.date(from:pairs.value["opendate"] as! String)!, closedate: formatter.date(from:pairs.value["closedate"] as! String)!, startingprice: pairs.value["startingprice"] as! Double, highestbidprice: pairs.value["highestbidprice"] as! Double, highestbidder: pairs.value["highestbidder"] as! String), forKey: pairs.key)
            }
            print("outside\(returndict)")
            print(self.appdelegate.SignedIn_UserKey!)
            //Populate recycler view here
            
        }
    
    
    }
}
