//
//  HomeFeedViewController.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import UIKit
import Firebase

class HomeFeedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var HomeFeedTableView: UITableView!
    var AuctionItemDictionary:[String:AuctionItem] = [:]
    var AuctionItemList:[AuctionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        HomeFeedTableView.rowHeight = 450
        HomeFeedTableView.delegate = self
        HomeFeedTableView.dataSource = self
        
        //  Get data on first load & refresh to set
        retrieveData()
        HomeFeedTableView.reloadData()
        
        //  Implement Refresh Control
        HomeFeedTableView.refreshControl?.tintColor  = .white
        HomeFeedTableView.refreshControl = UIRefreshControl()
        HomeFeedTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        HomeFeedTableView.refreshControl?.addTarget(self, action: #selector(self.pullDownRefresh(_:)), for: .valueChanged)
    }
    
    //  Refresh on resuming this view
    override func viewDidAppear(_ animated: Bool) {
//        retrieveData()
        self.HomeFeedTableView.reloadData()
    }
    
    //  Drag down top to refresh
    @objc func pullDownRefresh(_ sender: AnyObject){
        retrieveData()
        self.HomeFeedTableView.reloadData()
        self.HomeFeedTableView.refreshControl!.endRefreshing()
    }

    //  TableView: Produce Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuctionItemList.count
    }
    //  TableView: Bind Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeFeedTableView.dequeueReusableCell(withIdentifier: "HFCustomCell") as! HomeFeedCustomCell
        let AuctionItem = AuctionItemList[indexPath.row]
        
        //  Cell Binding
        if let url = URL(string: AuctionItem.imageUrl){
            cell.Cell_ImageView.loadImage(from: url)
        }
        cell.Cell_ItemNameLabel.text = AuctionItem.productName
        cell.Cell_StartingPriceLabel.text? = "Starting at $\(String(format: "%.2f", AuctionItem.startingPrice))"
        cell.Cell_NowAtPrice_Label.text? = "Highest bidder's price $\(String(format: "%.2f", AuctionItem.highestBidPrice))"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, h:mm a"
        cell.Cell_ClosesOn_Label.text? = "Closes on, \(formatter.string(from: AuctionItem.closeDate))"
        return cell
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
                                                        uniquekey: pairs.key),
                                            forKey: pairs.key)}
                
                
                for (key, value) in self.AuctionItemDictionary {
                    self.AuctionItemList.append(AuctionItem(productname: value.productName, imageurl: value.imageUrl, openedby: value.openedBy, opendate: value.openDate, closedate: value.closeDate, startingprice: value.startingPrice, highestbidprice: value.highestBidPrice, highestbidder: value.highestBidder, uniquekey: value.uniqueKey))
                }
                self.HomeFeedTableView.reloadData()
               
                }
            }
}
