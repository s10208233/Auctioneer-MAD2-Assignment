//
//  OpenNewAuctionViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import Photos

class OpenNewAuctionViewController : UIViewController,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate, UITextFieldDelegate {
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    
    //  UIView Components
    @IBOutlet weak var UploadDisplay: UIImageView!
    @IBOutlet weak var ItemName_Input: UITextField!
    @IBOutlet weak var ClosingDate_Input: UIDatePicker!
    //    @IBOutlet weak var ClosingDate_Input: UITextField!
    @IBOutlet weak var StartingPrice_input: UITextField!
    
    
    //  For Image Picker
    var imagePickerController = UIImagePickerController()
    var imagePickerSourceURL:URL!
    var returnedImageUrl:String = ""
    var didUploadImage:Bool = false

    //  For Date Picker
    let datepicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Preparation
        StartingPrice_input.delegate = self
        StartingPrice_input.keyboardType = .decimalPad
        //  Create date picker for Closing Date Input
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UploadDisplay.image = nil
        ClosingDate_Input.date = Date()
        ItemName_Input.text = ""
        StartingPrice_input.text = ""
    }
    
    
    //  UIView Button Action
    @IBAction func Select_Item_Image(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
//        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
//        self.imagePickerController.sourceType = .photoLibrary
//        self.imagePickerController.allowsEditing = true
//        self.present(self.imagePickerController, animated: true, completion: nil)
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
            UploadDisplay.image = image
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
                      self.didUploadImage = true
                      self.returnedImageUrl = url!.absoluteString
                  }
              }
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //  Date Picker
//    func createDatePicker() {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
//
//        ClosingDate_Input.inputAccessoryView = toolbar
//
//        ClosingDate_Input.inputView = datepicker
//        toolbar.setItems([doneBtn], animated: true)
//
//        datepicker.datePickerMode = .dateAndTime
//    }
//
//    func doneEventForDatePicker(){
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        ClosingDate_Input.text = formatter.string (from: datepicker.date)
//        self.view.endEditing(true)
//
//    }

    
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
    
    @IBAction func Submit_Auction(_ sender: Any) {
        //  Missing Input Validation
        if (didUploadImage == false) {
            let alert = UIAlertController(title: "Missing/Invalid Product Information", message: "Please select an image for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (ItemName_Input.text == nil || ItemName_Input.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Product Information", message: "Please give a name for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (StartingPrice_input.text == nil || StartingPrice_input.text == "") {
            let alert = UIAlertController(title: "Missing/Invalid Product Information", message: "Please give a starting price for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else if (ClosingDate_Input.date < Date()) {
            let alert = UIAlertController(title: "Missing/Invalid Product Information", message: "Please give a valid closing time, your closing time has passed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default,handler: { [weak self] (_) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            // UPLOAD PRODUCT HERE
            //  1st upload image then get back image url from firebase
            //  then create AuctionItem object and store into firebase
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM y, h:mm a"
            
            let ref = Database.database().reference()
            ref.child("Products/").childByAutoId().setValue(["productname": ItemName_Input.text!,"imageurl": returnedImageUrl,"openby": appdelegate.SignedIn_UserName!,"opendate": formatter.string(from: Date()),"closedate":formatter.string(from:ClosingDate_Input.date),"startingprice":Double(StartingPrice_input.text!)!,"highestbidprice":0,"highestbidder":"-"])
            
            ref.child("Users").observeSingleEvent(of: .value){
                (snapshot) in
                let users = snapshot.value as? [String:Dictionary<String, Any>]
                users?.forEach{ pairs in
                    if (pairs.value["Username"] as! String == self.appdelegate.SignedIn_UserName){
                        ref.child("Users").child(pairs.key).updateChildValues(["ItemsAuctioned":pairs.value["ItemsAuctioned"] as! Int + 1])            
                    }
                }
                
            }
            self.tabBarController?.selectedIndex = 0
        }
        
//        // UPLOAD PRODUCT HERE
//        //  1st upload image then get back image url from firebase
//        //  then create AuctionItem object and store into firebase
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        
//        let ref = Database.database().reference()
//        ref.child("Products/").childByAutoId().setValue(["productname": ItemName_Input.text!,"imageurl": returnedImageUrl,"openby": appdelegate.SignedIn_UserName!,"opendate": formatter.string(from: Date()),"closedate":formatter.string(from:ClosingDate_Input.date),"startingprice":Double(StartingPrice_input.text!)!,"highestbidprice":0,"highestbidder":"-"])
            
      
        
    }
}
