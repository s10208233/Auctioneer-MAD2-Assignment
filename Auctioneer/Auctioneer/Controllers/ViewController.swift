//
//  ViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 9/1/22.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tempUrl:URL!
    var imagePickerController = UIImagePickerController()
    
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    var product_uploads_dict2:[String:ProductUpload] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let storage = Storage.storage()
        var storageRef = storage.reference()
        //  Image Picker
        imagePickerController.delegate = self
        // Retrieve Image
        // Create a reference to the file you want to download
        let imageRef = storageRef.child("product_images/Screenshot 2022-01-08 at 10.50.04 PM.png")
        // Fetch the download URL
        imageRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
              print(url!)
          }
        }
        
        let newsTask = Task {await RetrieveProducts()}
        
    }
    
    func RetrieveProducts()async->[String:ProductUpload]{
        //Retrieve products
        let db = Firestore.firestore()
        db.collection("product_uploads").getDocuments { (snapshot, error) in
                snapshot!.documents.forEach({ (document) in
                    let pair = ProductUpload_Response(snapshot: document)
                    let thisProductUpload:ProductUpload = ProductUpload(userkey: pair.userKey, imageurl: pair.imageUrl)
                    self.product_uploads_dict2.updateValue(thisProductUpload, forKey: document.documentID)
                    })
            
                }



        return product_uploads_dict2
    }
    
    @IBAction func upload_button_tapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
        
        print("your mom\(product_uploads_dict2)")
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
            let storage = Storage.storage()
            var storageRef = storage.reference()

            tempUrl = url
            let imageRef = storageRef.child("product_images/lol1")
            let uploadTask = imageRef.putFile(from: tempUrl, metadata: nil) {metadata, error in
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
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

