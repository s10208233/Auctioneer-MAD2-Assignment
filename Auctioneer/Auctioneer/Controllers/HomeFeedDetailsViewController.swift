//
//  HomeFeedDetailsViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 21/1/22.
//

import UIKit
import FirebaseDatabase
import Foundation

class HomeFeedDetailsViewController : UIViewController {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    //  View Vars from View/Storyboard
    @IBOutlet weak var Item_CustomImageView: CustomImageView!
    @IBOutlet weak var ClosingDate_Label: UILabel!
    @IBOutlet weak var OpenDate_Label: UILabel!
    @IBOutlet weak var OpenedBy_Label: UILabel!
    @IBOutlet weak var HighestBidder_Label: UILabel!
    @IBOutlet weak var HighestBiddingPrice_Label: UILabel!
    @IBOutlet weak var NewBidAmount_Input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisAuctionItem:AuctionItem = (appdelegate.SelectedToViewAuctionItem)!
        
        if let url = URL(string: thisAuctionItem.imageUrl){
            Item_CustomImageView.loadImage(from: url)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, h:mm a"
        ClosingDate_Label.text? = formatter.string(from: thisAuctionItem.closeDate)
        ClosingDate_Label.text? = formatter.string(from: thisAuctionItem.openDate)
        OpenedBy_Label.text = thisAuctionItem.openedBy
        HighestBidder_Label.text = thisAuctionItem.highestBidder
        HighestBiddingPrice_Label.text = "$\(String(format: "%.2f", thisAuctionItem.highestBidPrice))"
    }
    
}
