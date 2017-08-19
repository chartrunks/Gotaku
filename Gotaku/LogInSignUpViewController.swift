//
//  LogInSignUpViewController.swift
//  Gotaku
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil{ //have verified and logged in{
            performSegue(withIdentifier: "autoLogInSegue", sender: nil)
            let alertVC = UIAlertController(title: "User", message: "\(Auth.auth().currentUser?.email!)", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(oKAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}
