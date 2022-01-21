//
//  AuctionWonViewController.swift
//  Auctioneer
//
//  Created by Shion on 21/1/22.
//

import Foundation
import UIKit
import Firebase

class AuctionWonViewController: UITableViewController {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var AuctionItemDictionary:[String:AuctionItem] = [:]
    var AuctionItemList:[AuctionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
        retrieveData()
//        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuctionItemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let AuctionItem = AuctionItemList[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AWCell", for: indexPath)
            let image = cell.imageView as? CustomImageView
            if let url = URL(string: AuctionItem.imageUrl){
                image?.loadImage(from: url)
            }
            cell.textLabel!.text = AuctionItem.productName
            cell.detailTextLabel!.text = "Starting at $\(AuctionItem.startingPrice), " + "Won at $\(AuctionItem.highestBidPrice)"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    //  Update Selected Auction Item in Appdelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.SelectedToViewAuctionItem = AuctionItemList[indexPath.row]
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
                    if (value.highestBidder == self.appDelegate.SignedIn_UserName! && value.isnotClosed == false){
                        self.AuctionItemList.append(AuctionItem(productname: value.productName, imageurl: value.imageUrl, openedby: value.openedBy, opendate: value.openDate, closedate: value.closeDate, startingprice: value.startingPrice, highestbidprice: value.highestBidPrice, highestbidder: value.highestBidder, uniquekey: value.uniqueKey,isnotclosed: value.isnotClosed))
                    }
                }
                self.tableView.reloadData()
                }
            }

}

