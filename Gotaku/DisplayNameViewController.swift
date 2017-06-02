//
//  DisplayNameViewController.swift
//  Gotaku
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayNameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("displayName").setValue(nameTextField.text!)
        
        performSegue(withIdentifier: "displayPicSegue", sender: nil)
    }
    
    
}
