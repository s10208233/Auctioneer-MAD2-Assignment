//
//  SignUpViewController.swift
//  Auctioneer
//
//  Created by Shion on 18/1/22.
//

import Foundation
import FirebaseDatabase
import UIKit

class SignUpViewController: UIViewController {
    var user:User = User(Username: "", Password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        //  Missing Input Validation
        if (newUsername.text == nil || newUsername.text == "") {
            let alert = UIAlertController(title: "Missing Username", message: "The username field is empty, please make sure that the username and password are filled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        if (newPassword.text == nil || newPassword.text == "") {
            let alert = UIAlertController(title: "Missing Password", message: "The username field is empty, please make sure that the username and password are filled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
        let ref = Database.database().reference()
        
        user = User(Username: newUsername.text!, Password: newPassword.text!)
        ref.child("Users/").childByAutoId().setValue(["Username":newUsername.text!,"Password":newPassword.text!])
    }
    
}


