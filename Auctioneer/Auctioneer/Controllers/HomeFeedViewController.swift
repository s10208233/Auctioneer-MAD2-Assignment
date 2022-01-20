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
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate

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
        }
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
}
