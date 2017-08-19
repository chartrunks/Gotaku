//
//  AddActorDescriptionViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddActorDescriptionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var callback : (([String:Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if actor.description != ""{
            textView.text = actor.description
            actorInfo["description"] = actor.description
        }
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func doneTapped(_ sender: Any) {
        actorInfo["description"] = textView.text
        if actor.actorID != "" && actor.roles != []{
            actorInfo["roles"] = actor.roles.joined(separator: " ")
        }
        
        //Gets folder
        let imagesFolder = Storage.storage().reference().child("actorpics")
        
        if actorInfo["picURLS"] != nil{
        if actorInfo["picURLs"] as! String == "\(actorInfo["actorID"])00.jpg"{
            imagesFolder.child("\(actorInfo["picURLs"])").putData(actorInfo["picData"] as! Data, metadata: nil, completion: { (metadata, error) in
                print("We tried to upload!")
                if error != nil {
                    print("An error occured: \(error)")
                } else {
                    //Perform segue after finished if no errors and sends URL to prepare
                    
                    self.actorInfo["picURLs"] = metadata?.downloadURL()?.absoluteString
                    self.actorInfo.removeValue(forKey: "picData")
                    self.actorInfo.removeValue(forKey: "photoName")
                    
                    
                    Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
                    self.performSegue(withIdentifier: "addActorRoleSegue", sender: nil)
                }
            })
            }
        } else {
            Database.database().reference().child("actorInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                var enteredActors = (snapshot.value as! NSDictionary)["enteredActors"] as! [String:String]
                enteredActors[self.actorInfo["actorID"] as! String] = self.actorInfo["name"] as! String
                Database.database().reference().child("actorInfo").child("enteredActors").setValue(enteredActors)
            })
            Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
            self.performSegue(withIdentifier: "addActorRoleSegue", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddLocationTypeViewController
        nextVC.initialVC = "actor"
    }

}
