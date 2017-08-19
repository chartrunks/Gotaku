//
//  AddActorSocialMediaViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddActorSocialMediaViewController: UIViewController {
    
    @IBOutlet weak var agencyTextField: UITextField!
    
    @IBOutlet weak var agencyURLTextField: UITextField!
    
    @IBOutlet weak var twitterTextField: UITextField!
    
    @IBOutlet weak var blogTextField: UITextField!
    
    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var edit = false
    
    var callback : (([String:Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if actor.agency != ""{
            agencyTextField.text = actor.agency
            actorInfo["agency"] = actor.agency
        }
        if actor.agencyURL != ""{
            agencyURLTextField.text = actor.agencyURL
            actorInfo["agencyURL"] = actor.agencyURL
        }
        if actor.twitterURL != ""{
            twitterTextField.text = actor.twitterURL
            actorInfo["twitterURL"] = actor.twitterURL
        }
        if actor.blogURL != ""{
            blogTextField.text = actor.blogURL
            actorInfo["blogURL"] = actor.blogURL
        }
    }
    @IBAction func nextTapped(_ sender: Any) {
        actorInfo["agency"] = agencyTextField.text
        actorInfo["agencyURL"] = agencyURLTextField.text
        actorInfo["twitterURL"] = twitterTextField.text
        actorInfo["blogURL"] = blogTextField.text
        if edit == false{
            performSegue(withIdentifier: "addActorDescriptionSegue", sender: nil)
        } else {
            Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
            callback?(self.actorInfo)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddActorDescriptionViewController
        nextVC.actorInfo = actorInfo
        nextVC.actor = actor
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    
}
