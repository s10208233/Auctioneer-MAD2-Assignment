//
//  YourListingsDetailsViewController.swift
//  Auctioneer
//
//  Created by Shion on 22/1/22.
//

import UIKit
import FirebaseDatabase
import Foundation

class YourListingsDetailsViewController : UIViewController,UITextFieldDelegate {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    //  View Vars from View/Storyboard
    @IBOutlet weak var Item_CustomImageView: CustomImageView!
    @IBOutlet weak var ClosingDate_Label: UILabel!
    @IBOutlet weak var OpenDate_Label: UILabel!
    @IBOutlet weak var HighestBidder_Label: UILabel!
    @IBOutlet weak var HighestBiddingPrice_Label: UILabel!
    @IBOutlet weak var StartingPrice_Label: UILabel!
    
    
//    var minimumBid:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thisAuctionItem:AuctionItem = (appdelegate.SelectedToViewAuctionItem)!
        let auctionItemRef = Database.database().reference().child("Products").child("\((self.appdelegate.SelectedToViewAuctionItem?.uniqueKey)!)")
        title = thisAuctionItem.productName
        
        if let url = URL(string: thisAuctionItem.imageUrl){
            Item_CustomImageView.loadImage(from: url)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, h:mm a"
        ClosingDate_Label.text? = formatter.string(from: thisAuctionItem.closeDate)
        ClosingDate_Label.text? = formatter.string(from: thisAuctionItem.openDate)
        StartingPrice_Label.text! = "\(thisAuctionItem.startingPrice as! Double)"
        
        auctionItemRef.observeSingleEvent(of: .value){ (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.HighestBidder_Label.text = "$\(value?["highestbidder"] as! String)"
            self.HighestBiddingPrice_Label.text =  "$\(value?["highestbidprice"] as! Double)"
            self.appdelegate.SelectedToViewAuctionItem?.highestBidPrice = value?["highestbidprice"] as! Double
            
            }
        }
    
    //Delete Listing
    @IBAction func Delete_Listing(_ sender: Any) {
        let auctionItemRef = Database.database().reference().child("Products").child("\((self.appdelegate.SelectedToViewAuctionItem?.uniqueKey)!)")
        auctionItemRef.removeValue()
        self.tabBarController?.selectedIndex = 2
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
}
