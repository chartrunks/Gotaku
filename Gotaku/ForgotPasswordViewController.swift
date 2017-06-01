//
//  ForgotPasswordViewController.swift
//  Gotaku
//
//  Created by Mac on 5/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func resetTapped(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error != nil{
                let alertVC = UIAlertController(title: "Incorrect Email", message: "The email you entered is incorrect. Please try again.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Reset Password Email Sent", message: "An email from Gotaku has been sent to your email address. Please follow the included link to reset your password and then log in with your new password.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}
