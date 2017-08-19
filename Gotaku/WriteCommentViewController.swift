//
//  WriteCommentViewController.swift
//  Gotaku
//
//  Created by Mac on 6/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class WriteCommentViewController: UIViewController {
    
    var locID = ""
    
    var eventID = ""
    
    var rating = 0.0
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var starsView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.layer.borderWidth = 1
        
        //Don't show rating if they are just leaving a comment
        if rating == 0.0{
            starsView.isHidden = true
        }
        
        else {
        //Set up rating view
        starsView.updateOnTouch = false
        starsView.filledColor = UIColor.red
        starsView.starMargin = 0
        starsView.fillMode = 0
        starsView.emptyBorderColor = UIColor.clear
        starsView.filledBorderColor = UIColor.clear
        starsView.rating = rating
        starsView.emptyColor = UIColor.lightGray
        starsView.starSize = 25
        }
        Database.database().reference().child("userInfo").child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in

            let picURL = (snapshot.value as! NSDictionary)["displayPicURL"] as! String
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                self.imageView?.image = image
                
            })
        })
    }

    @IBAction func postTapped(_ sender: Any) {
        Database.database().reference().child("userInfo").child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let time = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
            let username = (snapshot.value as! NSDictionary)["displayName"] as! String
            let text = self.textView.text
            let userPicURL = (snapshot.value as! NSDictionary)["displayPicURL"] as! String
            let comment = ["fromDisplayPicURL": userPicURL, "fromUser": username, "text": text, "time": time, "rating": self.rating] as [String : Any]
            if self.locID != ""{
                Database.database().reference().child("locationInfo").child("locations").child(self.locID).child("comments").childByAutoId().setValue(comment)
            } else {
                Database.database().reference().child("eventInfo").child("events").child(self.eventID).child("comments").childByAutoId().setValue(comment)
            }
            self.navigationController?.popViewController(animated: true)
    })
    }

}
