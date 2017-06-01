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
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        if Auth.auth().currentUser != nil {
//            performSegue(withIdentifier: "signInSegue", sender: nil)
//        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Attempting to sign in...")
            if error != nil {
                let alertVC = UIAlertController(title: "Incorrect Email/Password", message: "The email/password combination you entered is incorrect. Please try again.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                print("Signed in successfully!")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
            if error != nil{
                print("An error occured. We were unable to create an account. \(error)")
            } else {
                print("Created a user successfully!")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
            
        })
    }

}

