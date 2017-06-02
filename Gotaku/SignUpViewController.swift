//
//  SignUpViewController.swift
//  Gotaku
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
            if error != nil{
               if self.passwordTextField.text! == "" || self.emailTextField.text! == ""{
                let alertVC = UIAlertController(title: "Missing email/password", message: "You must enter a valid email and password.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else if self.passwordTextField.text!.characters.count < 6 {
                    let alertVC = UIAlertController(title: "Password too short", message: "Your password must be 6 characters long or more. Please try again.", preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(oKAction)
                    self.present(alertVC, animated: true, completion: nil)
                } else if !self.emailTextField.text!.characters.contains("@") || !self.emailTextField.text!.characters.contains("."){
                    let alertVC = UIAlertController(title: "Invalid email", message: "Please enter a valid email.", preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(oKAction)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "Email in use", message: "An account has already been created with this email address. If you forgot your password, please go to the Log In screen and select 'Forgot password?'.", preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(oKAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                
            } else {
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error != nil{
                        let alertVC = UIAlertController(title: "Error", message: "Encountered an error when trying to send the verification email. \(error)", preferredStyle: .alert)
                        let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertVC.addAction(oKAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    else {
                        Database.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        Database.database().reference().child("users").child(user!.uid).child("rank").setValue(0)
                        
                        let alertVC = UIAlertController(title: "Account created", message: "Your account has been created! A verification email was sent to your email address. Please verify your account and then log in.", preferredStyle: .alert)
                        let oKAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.performSegue(withIdentifier: "signUpLogInSegue", sender: nil)
                        })
                        alertVC.addAction(oKAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
                
            }
        })
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let nextVC = segue.destination as! SignInViewController
            nextVC.newUser = true
        }
    

}
