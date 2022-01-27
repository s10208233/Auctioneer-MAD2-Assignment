//
//  AuctionWonViewController.swift
//  Auctioneer
//
//  Created by Shion on 21/1/22.
//

import Foundation
import UIKit
import Firebase

class AuctionWonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var AuctionWonTableView: UITableView!
    var AuctionItemDictionary:[String:AuctionItem] = [:]
    var AuctionItemList:[AuctionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuctionWonTableView.rowHeight = 125
        AuctionWonTableView.delegate = self
        AuctionWonTableView.dataSource = self
        retrieveData()
        
        //  Implement Refresh Control
        AuctionWonTableView.refreshControl?.tintColor  = .white
        AuctionWonTableView.refreshControl = UIRefreshControl()
        AuctionWonTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        AuctionWonTableView.refreshControl?.addTarget(self, action: #selector(self.pullDownRefresh(_:)), for: .valueChanged)
        
        //  Observer
        let ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value){
            (snapshot) in
            let users = snapshot.value as? [String:Dictionary<String, Any>]
            users?.forEach{ pairs in
                if (pairs.value["Username"] as! String == self.appdelegate.SignedIn_UserName){
                    ref.child("Users").child(pairs.key).updateChildValues(["AuctionsWon": self.AuctionItemList.count])
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AuctionWonTableView.reloadData()
    }

    //  Drag down top to refresh
    @objc func pullDownRefresh(_ sender: AnyObject){
        retrieveData()
        AuctionWonTableView.reloadData()
        AuctionWonTableView.refreshControl!.endRefreshing()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuctionItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = AuctionWonTableView.dequeueReusableCell(withIdentifier: "CustomAWCell") as! CustomAWCell
            let AuctionItem = AuctionItemList[indexPath.row]
            
            cell.Cell_ProductName_Label!.text = AuctionItem.productName
            if let url = URL(string: AuctionItem.imageUrl){
                cell.Cell_ImageView.loadImage(from: url)
            }
            cell.Cell_WonAt_Label!.text = "$\(AuctionItem.highestBidPrice)"
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
                    if (value.highestBidder == self.appdelegate.SignedIn_UserName! && value.isnotClosed == false){
                        self.AuctionItemList.append(AuctionItem(productname: value.productName, imageurl: value.imageUrl, openedby: value.openedBy, opendate: value.openDate, closedate: value.closeDate, startingprice: value.startingPrice, highestbidprice: value.highestBidPrice, highestbidder: value.highestBidder, uniquekey: value.uniqueKey,isnotclosed: value.isnotClosed))
                    }
                }
                self.AuctionWonTableView.reloadData()
                }
            }

}

