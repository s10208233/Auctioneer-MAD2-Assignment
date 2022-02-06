//
//  AuctionWonDetailsViewController.swift
//  Auctioneer
//
//  Created by Shion on 22/1/22.
//

import UIKit
import FirebaseDatabase
import Foundation

class AuctionWonDetailsViewController : UIViewController,UITextFieldDelegate {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    //  View Vars from View/Storyboard
    @IBOutlet weak var Item_CustomImageView: CustomImageView!
    @IBOutlet weak var OpenDate_Label: UILabel!
    @IBOutlet weak var StartingPrice_Label: UILabel!
    @IBOutlet weak var HighestBiddingPrice_Label: UILabel!
    @IBOutlet weak var CloseDate_Label: UILabel!
    @IBOutlet weak var OpenedBy_Label: UILabel!
    
    
    
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
        OpenDate_Label.text? = formatter.string(from: thisAuctionItem.openDate)
        StartingPrice_Label.text! = "$\(thisAuctionItem.startingPrice as! Double)"
        HighestBiddingPrice_Label.text =  "$\(thisAuctionItem.highestBidPrice as! Double)"
        OpenedBy_Label.text = "\(thisAuctionItem.openedBy as! String)"
        CloseDate_Label.text = formatter.string(from: thisAuctionItem.closeDate)
        

    }
    
    
}

