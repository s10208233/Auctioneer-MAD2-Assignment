//
//  YourListingsViewController.swift
//  Auctioneer
//
//  Created by Shion on 21/1/22.
//

import Foundation
import UIKit
import Firebase

class YourListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var YourListingTableView: UITableView!
    var AuctionItemDictionary:[String:AuctionItem] = [:]
    var AuctionItemList:[AuctionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YourListingTableView.rowHeight = 125
        YourListingTableView.delegate = self
        YourListingTableView.dataSource = self
        retrieveData()
        
        //  Implement Refresh Control
        YourListingTableView.refreshControl?.tintColor  = .white
        YourListingTableView.refreshControl = UIRefreshControl()
        YourListingTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        YourListingTableView.refreshControl?.addTarget(self, action: #selector(self.pullDownRefresh(_:)), for: .valueChanged)
        
//        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        YourListingTableView.reloadData()
    }
    
    //  Drag down top to refresh
    @objc func pullDownRefresh(_ sender: AnyObject){
        retrieveData()
        self.YourListingTableView.reloadData()
        self.YourListingTableView.refreshControl!.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuctionItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = YourListingTableView.dequeueReusableCell(withIdentifier: "CustomYLCell") as! CustomYLCell
            let AuctionItem = AuctionItemList[indexPath.row]
            
            cell.Cell_ProductNameLabel!.text = AuctionItem.productName
            if let url = URL(string: AuctionItem.imageUrl){
                cell.Cell_ImageView.loadImage(from: url)
            }
            if (AuctionItem.isnotClosed == true){
                cell.Cell_Status.text? = "Open"
            }
            else{
                cell.Cell_Status.text? = "Closed"
                cell.Cell_Status.textColor = .red
            }
            cell.Cell_HighestBid_Label.text? = "\(AuctionItem.highestBidPrice)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    //  Update Selected Auction Item in Appdelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appdelegate.SelectedToViewAuctionItem = AuctionItemList[indexPath.row]
    }

    
    //  DATA
    func retrieveData(){
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM y, h:mm a"
            let ref = Database.database().reference()
            ref.child("Products").observe(.value){ (snapshot) in
                self.AuctionItemList = []
                self.AuctionItemDictionary = [:]
            let products = snapshot.value as? [String:Dictionary<String, Any>]
            products?.forEach{ pairs in()
                self.AuctionItemDictionary.updateValue(AuctionItem(productname: pairs.value["productname"] as! String,
                                                        imageurl: pairs.value["imageurl"] as! String,
                                                        openedby: pairs.value["openby"] as! String,
                                                        opendate: formatter.date(from:pairs.value["opendate"] as! String)!,
                                                        closedate: formatter.date(from:pairs.value["closedate"] as! String)!,
                                                        startingprice: pairs.value["startingprice"] as! Double,
                                                        highestbidprice: Double("\(pairs.value["highestbidprice"]!)")!,
                                                        highestbidder: pairs.value["highestbidder"] as! String,
                                                        uniquekey: pairs.key,
                                                        isnotclosed: Date().isBetween(formatter.date(from:pairs.value["opendate"] as! String)!, and: formatter.date(from:pairs.value["closedate"] as! String)!)),
                                            forKey: pairs.key)}
                
                
                for (key, value) in self.AuctionItemDictionary {
                    if (value.openedBy == self.appdelegate.SignedIn_UserName!){
                        self.AuctionItemList.append(AuctionItem(productname: value.productName, imageurl: value.imageUrl, openedby: value.openedBy, opendate: value.openDate, closedate: value.closeDate, startingprice: value.startingPrice, highestbidprice: value.highestBidPrice, highestbidder: value.highestBidder, uniquekey: value.uniqueKey,isnotclosed: value.isnotClosed))
                    }
                }
                self.YourListingTableView.reloadData()
                }
            }

}
