//
//  AddActorNameViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddActorNameViewController: UIViewController {

    @IBOutlet weak var enFamilyNameTextField: UITextField!
    
    @IBOutlet weak var enFirstNameTextField: UITextField!
    
    @IBOutlet weak var jpFamilyNameTextField: UITextField!
    
    @IBOutlet weak var jpFirstNameTextField: UITextField!
    
    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var edit = false
    
    var callback : (([String:Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if actor.actorID != ""{
            var enName = actor.englishName.components(separatedBy: " ")
            let jpName = actor.japaneseName
            enFamilyNameTextField.text = enName[0]
            enFirstNameTextField.text = enName[1]
            jpFamilyNameTextField.text = jpName
            
            actorInfo["englishName"] = actor.englishName
            actorInfo["japaneseName"] = actor.japaneseName
            actorInfo["actorID"] = actor.actorID
        }
    }
    @IBAction func nextTapped(_ sender: Any) {
        let id = "\(jpFamilyNameTextField.text!)\(jpFirstNameTextField.text!)"
        actorInfo["englishName"] = "\(enFamilyNameTextField.text!) \(enFirstNameTextField.text!)"
        
        actorInfo["photoName"] = "\(enFamilyNameTextField.text!.lowercased())\(enFirstNameTextField.text!.lowercased())"
        actorInfo["japaneseName"] = id
        actorInfo["actorID"] = id
        
        if edit == false{
        performSegue(withIdentifier: "addActorPicSegue", sender: nil)
        } else {
            Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
            callback?(self.actorInfo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddActorPicViewController
        nextVC.actorInfo = actorInfo
        nextVC.actor = actor
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

}
