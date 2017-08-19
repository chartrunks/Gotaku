//
//  DisplayPicViewController.swift
//  Gotaku
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class DisplayPicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var skipNextButton: UIButton!
    
    var displayName = ""
    
    var imagePicker = UIImagePickerController()
    
    var imageSelected = false
    
    //random name for each image
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = RBSquareImageTo(image: image, size: CGSize(width: 75.0, height: 75.0))
        
        imageView.backgroundColor = UIColor.clear
        
        //Changes to next once they select an image
        skipNextButton.setTitle("Next", for: UIControlState.normal)
        
        //Tells button they selected an image
        imageSelected = true
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipNextTapped(_ sender: Any) {
        if imageSelected == true{
        //Disable next button so they can't keep clicking while it's loading
        skipNextButton.isEnabled = false
        
        //Uploads image before segue
        
        //Gets folder
        let imagesFolder = Storage.storage().reference().child("displaypics")
        
        //Converts image to data we can use
        let imageData = UIImageJPEGRepresentation((imageView?.image!)!, 0.1)!
        
        
        //Uploads data
        imagesFolder.child("\(Auth.auth().currentUser?.uid).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
            print("We tried to upload!")
            if error != nil {
                print("An error occured: \(error)")
            } else {
                //Perform segue after finished if no errors and sends URL to prepare
                Database.database().reference().child("userInfo").child("users").child((Auth.auth().currentUser?.uid)!).child("displayPicURL").setValue(metadata?.downloadURL()?.absoluteString)
                
                self.performSegue(withIdentifier: "newLogInSegue", sender: nil)
            }
        })
        
        } else {
            Database.database().reference().child("userInfo").child("users").child((Auth.auth().currentUser?.uid)!).child("displayPicURL").setValue("No image :(")
            performSegue(withIdentifier: "newLogInSegue", sender: nil)
        }
    }
    
    @IBAction func selectTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}
