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
        var bool:Bool = true
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
        ref.child("Users").observeSingleEvent(of: .value){
            (snapshot) in
            let users = snapshot.value as? [String:Dictionary<String, Any>]
            users?.forEach{ pairs in
                if (pairs.value["Username"] as! String == self.newUsername.text!)
                {
                    let alert = UIAlertController(title: "Signup Failed", message: "The name you have entereted already exist, Please enter another name.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    bool = false
                }
            }
            if (bool){
                self.user = User(Username: self.newUsername.text!, Password: self.newPassword.text!)
                ref.child("Users/").childByAutoId().setValue(["Username":self.newUsername.text!,"Password":self.newPassword.text!,"ItemsAuctioned":0,"AuctionsWon":0,"ProfileImage":""])
                //  Prompt users that login is sucessful and redirect to login page
                let alert = UIAlertController(title: "Success", message: "Your account has been created! Login now to start using Auctioneer!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {[weak alert] (_) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginPage") as UIViewController
                    vc.modalPresentationStyle = .fullScreen // try without fullscreen?
                    self.present(vc, animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
        

        
        
        
        

    }
    
}


