//
//  HomeFeedViewController.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import FirebaseDatabase
import UIKit

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let testitems = [

    AuctionItem(
        productname: "This Cat",
        imageurl: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/domestic-cat-lies-in-a-basket-with-a-knitted-royalty-free-image-1592337336.jpg",
        openedby: "SampleUsername",
        opendate: Date(), closedate: Date(),
        startingprice: 1.00, highestbidprice: 0.0,
        highestbidder: "AnotherSampleUsername")
    ,
    AuctionItem(
        productname: "This Cat",
        imageurl: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/domestic-cat-lies-in-a-basket-with-a-knitted-royalty-free-image-1592337336.jpg",
        openedby: "SampleUsername",
        opendate: Date(), closedate: Date(),
        startingprice: 1.00, highestbidprice: 0.0,
        highestbidder: "AnotherSampleUsername")
    ,
    AuctionItem(
        productname: "This Cat",
        imageurl: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/domestic-cat-lies-in-a-basket-with-a-knitted-royalty-free-image-1592337336.jpg",
        openedby: "SampleUsername",
        opendate: Date(), closedate: Date(),
        startingprice: 1.00, highestbidprice: 0.0,
        highestbidder: "AnotherSampleUsername")
    ]
    
    @IBOutlet weak var HomeFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeFeedTableView.delegate = self
        HomeFeedTableView.dataSource = self
    }
    
    //  TableView Cell bindings
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //  Cell Height
        return 165
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeFeedTableView.dequeueReusableCell(withIdentifier: "HFCustomCell") as! HomeFeedCustomCell
        let AuctionItem = testitems[indexPath.row]
        
        //  Cell Binding
        if let url = URL(string: AuctionItem.imageUrl){
            cell.Cell_ImageView.loadImage(from: url)
        }
//        cell.Cell_ImageView.loadImage(from: URL(string: AuctionItem.imageUrl) as! URL)
//        cell.Cell_ImageView.load(urlString: AuctionItem.imageUrl)
        cell.Cell_ItemNameLabel.text = AuctionItem.productName
        cell.Cell_StartingPriceLabel.text? = "Starting at $\(String(format: "%.2f", AuctionItem.startingPrice))"
        cell.Cell_NowAtPrice_Label.text? = "Currently at $\(String(format: "%.2f", AuctionItem.highestBidPrice))"
        return cell
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
