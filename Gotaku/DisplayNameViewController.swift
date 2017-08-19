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
        Database.database().reference().child("userInfo").child("takenDisplayNames").observeSingleEvent(of: .value, with: { (snapshot) in
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-")
            if snapshot.hasChild(self.nameTextField.text!){
                let alertVC = UIAlertController(title: "Username in use", message: "This username has been taken. Please choose another.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else if self.nameTextField.text!.characters.count < 6 || self.nameTextField.text!.characters.count > 20 {
                let alertVC = UIAlertController(title: "Invalid username", message: "Please enter a username between 6 and 20 characters in length.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else if self.nameTextField.text!.rangeOfCharacter(from: characterset.inverted) != nil {
                let alertVC = UIAlertController(title: "Invalid username", message: "Username can only contain letters, numbers, '-', and '_'.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            else {
                Database.database().reference().child("userInfo").child("users").child((Auth.auth().currentUser?.uid)!).child("displayName").setValue(self.nameTextField.text!)
                Database.database().reference().child("userInfo").child("takenDisplayNames").child(self.nameTextField.text!).setValue(Auth.auth().currentUser?.uid)
                
                self.performSegue(withIdentifier: "displayPicSegue", sender: nil)
            }
        })
       
    }
    
    
}
