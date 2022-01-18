//
//  OpenNewAuctionViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import UIKit

class OpenNewAuctionViewController : UIViewController,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate

    var imagePickerController = UIImagePickerController()

    
    //  UIView Components
    @IBOutlet weak var UploadDisplay: UIImageView!
    @IBOutlet weak var ItemName_Input: UITextField!
    @IBOutlet weak var ClosingDate_Input: UITextField!
    @IBOutlet weak var StartingPrice_input: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //  UIView Button Action
    @IBAction func Select_Item_Image(_ sender: Any) {
        
    }
    
    @IBAction func Submit_Auction(_ sender: Any) {
        
    }
    
    
}
