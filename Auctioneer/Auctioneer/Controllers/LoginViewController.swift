//
//  LoginViewController.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation
import FirebaseDatabase

class LoginViewController : UIViewController {
    
    //  UIView Components
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    var Authenticated:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //  UIView Button Actions
    @IBAction func Submit_Login(_ sender: Any) {
        
        
        //  Missing Input Validation
        if (username_input.text == nil || username_input.text == "") {
            let alert = UIAlertController(title: "Missing Username", message: "The username field is empty, please make sure that the username and password are filled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        if (password_input.text == nil || password_input.text == "") {
            let alert = UIAlertController(title: "Missing Password", message: "The username field is empty, please make sure that the username and password are filled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
        //  User Authentication Validation
            //  retrieve existing users, loop through and check if un and pw == input, change 'Authenticated' bool to true

        let ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value){
            (snapshot) in
            let users = snapshot.value as? [String:Dictionary<String, Any>]
            
            users?.forEach{ pairs in

                if (pairs.value["Username"] as! String == self.username_input.text! && pairs.value["Password"] as! String == self.password_input.text!)
                {
                    print("authenticated")
                    self.appdelegate.SignedIn_UserKey = pairs.key
                    self.appdelegate.SignedIn_UserName = (pairs.value["Username"] as! String)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainBegin") as UIViewController
                    vc.modalPresentationStyle = .fullScreen // try without fullscreen?
                    self.present(vc, animated: true, completion: nil)
                }
            }
            let alert = UIAlertController(title: "Login Failed", message: "The credentials you've enter to login is incorrect or does not exist, please try again or sign up an account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }
        

    
    }
    
    
}
