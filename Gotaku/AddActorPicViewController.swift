//
//  AddActorPicViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddActorPicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()

    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var imageSelected = false
    
    var edit = false
    
    var callback : (([String:Any]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        if actor.picURLs != []{
        let picURL = actor.picURLs[0]
        Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
            let image = UIImage(data: data!)
            self.imageView?.image = image
            
        })
        actorInfo["picURLs"] = actor.picURLs[0]
        }
    }

    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func libraryTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
//        //Changes to next once they select an image
//        skipNextButton.setTitle("Next", for: UIControlState.normal)
        
//        //Tells button they selected an image
        imageSelected = true
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func nextTapped(_ sender: Any) {
        if imageView.image != nil && imageSelected == true{
            actorInfo["picURLs"] =  "\(actorInfo["photoName"]!)00.jpg"
            actorInfo["picData"] =  UIImageJPEGRepresentation((imageView?.image!)!, 0.2)!
            actorInfo["picDimensions"] = "\(imageView?.image?.size.width)/\(imageView?.image?.size.height)"
        }
        if edit == false{
        performSegue(withIdentifier: "addActorBirthdateSegue", sender: nil)
        } else {
            Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
            callback?(self.actorInfo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddActorBdayViewController
        nextVC.actorInfo = actorInfo
        nextVC.actor = actor
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}
