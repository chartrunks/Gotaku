//
//  SignInViewController.swift
//  Gotaku
//
//  Created by Mac on 5/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var newUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Attempting to sign in...")
            if error != nil {
                let alertVC = UIAlertController(title: "Incorrect Email/Password", message: "The email/password combination you entered is incorrect. Please try again.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else if !(((Auth.auth().currentUser)?.isEmailVerified)!) {
                let alertVC = UIAlertController(title: "Account not verified", message: "Please verify your email address by clicking the link in the email we sent you.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
        } else {
                print("Signed in successfully!")
                if !self.newUser {
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
                }
                else{
                    self.performSegue(withIdentifier: "displayNameSegue", sender: nil)
                }
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: nil)
    }
    

}

