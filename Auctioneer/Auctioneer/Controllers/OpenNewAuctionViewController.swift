//
//  OpenNewAuctionViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import UIKit
import FirebaseStorage
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
    
    //  For Date Picker
    let datepicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Preparation
        StartingPrice_input.delegate = self
        StartingPrice_input.keyboardType = .decimalPad
        //  Create date picker for Closing Date Input
        
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
            var storageRef = storage.reference()

            imagePickerSourceURL = url
            let imageRef = storageRef.child("product_images/lol1")
            let uploadTask = imageRef.putFile(from: imagePickerSourceURL, metadata: nil) {metadata, error in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              imageRef.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
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
        if (imagePickerSourceURL == nil || imagePickerSourceURL.absoluteString == "") {
            let alert = UIAlertController(title: "Missing Product Information", message: "Please select an image for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        if (ItemName_Input.text == nil || ItemName_Input.text == "") {
            let alert = UIAlertController(title: "Missing Product Information", message: "Please give a name for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        if (StartingPrice_input.text == nil || StartingPrice_input.text == "") {
            let alert = UIAlertController(title: "Missing Product Information", message: "Please give a starting price for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        if (StartingPrice_input.text == nil || StartingPrice_input.text == "") {
            let alert = UIAlertController(title: "Missing Product Information", message: "Please give a closing date & time for the item you are auctioning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        do{
            // UPLOAD PRODUCT HERE
            //  1st upload image then get back image url from firebase
            //  then create AuctionItem object and store into firebase
        }
        catch{
            print("Error creating product into firebase")
        }
    }
}
