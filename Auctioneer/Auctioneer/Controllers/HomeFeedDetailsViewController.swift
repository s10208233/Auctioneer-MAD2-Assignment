//
//  HomeFeedDetailsViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 21/1/22.
//

import UIKit
import FirebaseDatabase
import Foundation

class HomeFeedDetailsViewController : UIViewController,UITextFieldDelegate {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    //  View Vars from View/Storyboard
    @IBOutlet weak var Item_CustomImageView: CustomImageView!
    @IBOutlet weak var ClosingDate_Label: UILabel!
    @IBOutlet weak var OpenDate_Label: UILabel!
    @IBOutlet weak var OpenedBy_Label: UILabel!
    @IBOutlet weak var HighestBidder_Label: UILabel!
    @IBOutlet weak var HighestBiddingPrice_Label: UILabel!
    @IBOutlet weak var NewBidAmount_Input: UITextField!
    
    var minimumBid:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewBidAmount_Input.text = ""
        NewBidAmount_Input.keyboardType = .decimalPad
        NewBidAmount_Input.delegate = self
        NewBidAmount_Input.keyboardType = .decimalPad
        
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
        
        if (thisAuctionItem.highestBidPrice <= thisAuctionItem.startingPrice){
            minimumBid = thisAuctionItem.startingPrice
            NewBidAmount_Input.placeholder = "New Bid (Minimum $\(minimumBid!)"
        }
        else{
            minimumBid = thisAuctionItem.highestBidPrice+1
            NewBidAmount_Input.placeholder = "New Bid (Minimum $\(minimumBid!))"
        }
            
    }
    
    //  Decimal Limit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    //  New Bid
    @IBAction func Bid_Submit(_ sender: Any) {
        let thisAuctionItem:AuctionItem = (appdelegate.SelectedToViewAuctionItem)!
        let thisProductKey:String = appdelegate.SelectedToViewAuctionItem!.uniqueKey
        
        if (Double(NewBidAmount_Input.text!)! >= thisAuctionItem.startingPrice){
            let ref = Database.database().reference()
            ref.child("Products/").child(thisProductKey).child("highestbidprice").setValue(NewBidAmount_Input.text!)
        }
        else if (Double(NewBidAmount_Input.text!)! >= thisAuctionItem.highestBidPrice){
            let ref = Database.database().reference()
            ref.child("Products/").child(thisProductKey).child("highestbidprice").setValue(NewBidAmount_Input.text!)
        }
        else if (NewBidAmount_Input.text == ""){
            let alert = UIAlertController(title: "Invalid Amount", message: "Please enter a valid bid amount, the minimum bid amount for this item is $\(String(format: "%.2f", minimumBid!))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in }))
            present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Invalid Amount", message: "Please enter a valid bid amount, the minimum bid amount for this item is $\(String(format: "%.2f", minimumBid!))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}
