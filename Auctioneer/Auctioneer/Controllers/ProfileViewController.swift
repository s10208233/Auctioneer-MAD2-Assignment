//
//  ProfileViewController.swift
//  Auctioneer
//
//  Created by Shion on 22/1/22.
//

import Foundation
import UIKit
import Firebase
import Photos

class ProfileViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var AuctionItemDictionary:[String:AuctionItem] = [:]
    var AuctionItemList:[AuctionItem] = []
   
    //  For Image Picker
    var imagePickerController = UIImagePickerController()
    var imagePickerSourceURL:URL!
    
    //Vars
    @IBOutlet weak var ProfileImage_ImageView: CustomImageView!
    @IBOutlet weak var Username_Label: UILabel!
    @IBOutlet weak var ItemsAuctioned_Label: UILabel!
    @IBOutlet weak var ItemsWon_Label: UILabel!
    @IBOutlet weak var Earnings_Label: UILabel!
    @IBOutlet weak var Spending_Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        Username_Label.text! = appDelegate.SignedIn_UserName!
    }
    
    
    @IBAction func ChangeProfileImage_Button(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func SignOut_Button(_ sender: Any) {
        self.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
    
    //  DATA
    func retrieveData(){
        //Initialise viarables needed
        var Earnings:Double = 0
        var Spending:Double = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, h:mm a"
        let ref = Database.database().reference()
        
        //Retrieve User information
        ref.child("Users").observe( .value){(snapshot) in
            let users = snapshot.value as? [String:Dictionary<String, Any>]
            users?.forEach{ pairs in
                if (pairs.value["Username"] as! String == self.appDelegate.SignedIn_UserName!){
                    self.ItemsWon_Label.text! = "\(pairs.value["AuctionsWon"] as! Int)"
                    self.ItemsAuctioned_Label.text! = "\(pairs.value["ItemsAuctioned"] as! Int)"
                    if let url = URL(string: pairs.value["ProfileImage"] as! String){
                        self.ProfileImage_ImageView.loadImage(from: url)
                    }
                }
            }
        }
        
        //Retrieve Products
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
                                                    isnotclosed: Date().isBetween(formatter.date(from:pairs.value["opendate"] as! String)!, and: formatter.date(from:pairs.value["closedate"] as! String)!)), forKey: pairs.key)
        }
            
        //Checking through the products list
        for (key, value) in self.AuctionItemDictionary {
            if (value.highestBidder == self.appDelegate.SignedIn_UserName! && value.isnotClosed == false){
                //Auction WON
                Spending += value.highestBidPrice
            }
            if (value.openedBy == self.appDelegate.SignedIn_UserName! && value.isnotClosed == false && value.highestBidPrice > value.startingPrice){
                //Your Listings
                Earnings += value.highestBidPrice
            }
        }
    
        //Assign to label after it is done checking
        self.Spending_Label.text! = "\(Spending)"
        self.Earnings_Label.text! = "\(Earnings)"

        }
    }
    
    
    //  Check permission to access phone's library
    func checkPermission() {
        if (PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized) {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in () })
        }
        if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized) {}
        else { PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler) }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized) {
            print("Access to photos: Yes")
        }
        else {
            print("Access to photos: No")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("STUPID INFO \(info)")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            ProfileImage_ImageView.image = image
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            let storage = Storage.storage()
            let storageRef = storage.reference()
                
            imagePickerSourceURL = url
            let thisurl:String = url.absoluteString
            let fullNameArr = thisurl.components(separatedBy: "/")
            let firstName: String = fullNameArr[fullNameArr.count-1]
            let imageRef = storageRef.child("product_images/\(firstName)")

            let uploadTask = imageRef.putFile(from: imagePickerSourceURL, metadata: nil) {metadata, error in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
                imageRef.downloadURL { url, error in
                  if let error = error {
                    // Handle any errors
                      print(error)
                  } else {
                    // Get the download URL for 'images/stars.jpg'
                      print(url!)
                      let ref = Database.database().reference()
                      ref.child("Users").observeSingleEvent(of: .value){
                          (snapshot) in
                          let users = snapshot.value as? [String:Dictionary<String, Any>]
                          users?.forEach{ pairs in
                              if (pairs.value["Username"] as! String == self.appDelegate.SignedIn_UserName){
                                  ref.child("Users").child(pairs.key).updateChildValues(["ProfileImage":url!.absoluteString ])
                              }
                          }
                          
                      }
                  }
               }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
