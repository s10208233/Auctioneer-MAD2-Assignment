//
//  ViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 9/1/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var tempUrl:URL
    var imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let storage = Storage.storage()
        var storageRef = storage.reference()
        
        //  Image Picker
        imagePickerController.delegate = self
        
        // Create a reference to the file you want to download
        let starsRef = storageRef.child("product_images/Screenshot 2022-01-08 at 10.50.04 PM.png")

        // Fetch the download URL
        starsRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
              print(url)
          }
        }
        

    }
    
    
    //  Image Picker
    @IBAction func upload_button_tapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in () })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {}
        else { PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler) }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access to photos: Yes")
        }
        else {
            print("Access to photos: No")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
//            tempUrl = url
//            let imageRef = storageRef.child("product_images")
//
//            // Upload the file to the path "images/rivers.jpg"
//            let uploadTask = imageRef.putFile(from: tempUrl) { error in
//              guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//              }
//              // Metadata contains file metadata such as size, content-type.
//              let size = metadata.size
//              // You can also access to download URL after upload.
//              imageRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                  // Uh-oh, an error occurred!
//                  return
//                }
//              }
//            }
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

