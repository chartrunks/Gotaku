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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Attempting to sign in...")
            if error != nil {
                print("Unable to find an account with this email and password. Would you like to create an account?")
                //if answer == yes{
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    if error != nil{
                        print("An error occured. We were unable to create an account.")
                    } else {
                        print("Created a user successfully!")
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                    
                })
            } else {
                print("Signed in successfully!")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }

}

