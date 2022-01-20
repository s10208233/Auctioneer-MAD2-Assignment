//
//  HomeFeedViewController.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import FirebaseDatabase
import UIKit

class HomeFeedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    var returndict:[String:AuctionItem] = [:]
    var productList:[AuctionItem] = []

    
    @IBOutlet weak var HomeFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeFeedTableView.delegate = self
        HomeFeedTableView.dataSource = self
        
        //  Get data on first load & refresh to set
        retrieveData()
        HomeFeedTableView.reloadData()
        
        //  Implement Refresh Control
        HomeFeedTableView.refreshControl = UIRefreshControl()
        HomeFeedTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        HomeFeedTableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        productList = []
        retrieveData()
    }
    
    func retrieveData(){
            let formatter = DateFormatter()
            formatter.dateStyle = .short

            let ref = Database.database().reference()
            ref.child("Products").observeSingleEvent(of: .value){ (snapshot) in
                let products = snapshot.value as! [String:Dictionary<String, Any>]
                products.forEach{ pairs in()
                    self.returndict.updateValue(AuctionItem(productname: pairs.value["productname"] as! String, imageurl: pairs.value["imageurl"] as! String, openedby: pairs.value["openby"] as! String, opendate: formatter.date(from:pairs.value["opendate"] as! String)!, closedate: formatter.date(from:pairs.value["closedate"] as! String)!, startingprice: pairs.value["startingprice"] as! Double, highestbidprice: pairs.value["highestbidprice"] as! Double, highestbidder: pairs.value["highestbidder"] as! String), forKey: pairs.key)
                }
                
                for (key, value) in self.returndict {
                    self.productList.append(AuctionItem(productname: value.productName, imageurl: value.imageUrl, openedby: value.openedBy, opendate: value.openDate, closedate: value.closeDate, startingprice: value.startingPrice, highestbidprice: value.highestBidPrice, highestbidder: value.highestBidder))
                }
                print("outside\(self.returndict)")
                self.HomeFeedTableView.reloadData()
               
            }
        }
    
    @objc func refresh(_ sender: AnyObject){
        productList = []
        retrieveData()
        self.HomeFeedTableView.refreshControl!.endRefreshing()
    }

    
    //  TableView Cell bindings
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //  Cell Height
        return 165
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = HomeFeedTableView.dequeueReusableCell(withIdentifier: "HFCustomCell") as! HomeFeedCustomCell
//        let AuctionItem = testitems[indexPath.row]
//
//        //  Cell Binding
//        if let url = URL(string: AuctionItem.imageUrl){
//            cell.Cell_ImageView.loadImage(from: url)
//        }
////        cell.Cell_ImageView.loadImage(from: URL(string: AuctionItem.imageUrl) as! URL)
////        cell.Cell_ImageView.load(urlString: AuctionItem.imageUrl)
//        cell.Cell_ItemNameLabel.text = AuctionItem.productName
//        cell.Cell_StartingPriceLabel.text? = "Starting at $\(String(format: "%.2f", AuctionItem.startingPrice))"
//        cell.Cell_NowAtPrice_Label.text? = "Currently at $\(String(format: "%.2f", AuctionItem.highestBidPrice))"
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeFeedTableView.dequeueReusableCell(withIdentifier: "HFCustomCell") as! HomeFeedCustomCell
        let AuctionItem = productList[indexPath.row]
        
        //  Cell Binding
        if let url = URL(string: AuctionItem.imageUrl){
            cell.Cell_ImageView.loadImage(from: url)
        }
//        cell.Cell_ImageView.loadImage(from: URL(string: AuctionItem.imageUrl) as! URL)
//        cell.Cell_ImageView.load(urlString: AuctionItem.imageUrl)
        cell.Cell_ItemNameLabel.text = AuctionItem.productName
        cell.Cell_StartingPriceLabel.text? = "Starting at $\(String(format: "%.2f", AuctionItem.startingPrice))"
        cell.Cell_NowAtPrice_Label.text? = "Highest bidder's price $\(String(format: "%.2f", AuctionItem.highestBidPrice))"
        return cell
    }
}
