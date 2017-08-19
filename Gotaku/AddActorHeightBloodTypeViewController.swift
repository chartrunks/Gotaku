//
//  AddActorHeightBloodTypeViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddActorHeightBloodTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bloodTypePickerView: UIPickerView!
    
    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var edit = false
    
    var callback : (([String:Any]) -> Void)?
    
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bloodTypePickerView.delegate = self
        bloodTypePickerView.dataSource = self
        
        pickerData = ["A", "B", "AB", "O"]
        
        if actor.height != 0{
            heightTextField.text = "\(actor.height)"
            actorInfo["height"] = actor.height
        }
        if actor.bloodtype != ""{
            if actor.bloodtype == "A"{
                bloodTypePickerView.selectRow(0, inComponent: 0, animated: true)
            } else if actor.bloodtype == "B"{
                bloodTypePickerView.selectRow(1, inComponent: 0, animated: true)
            } else if actor.bloodtype == "AB"{
                bloodTypePickerView.selectRow(2, inComponent: 0, animated: true)
            } else{
                bloodTypePickerView.selectRow(3, inComponent: 0, animated: true)
            }
            actorInfo["bloodType"] = actor.bloodtype
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    @IBAction func nextTapped(_ sender: Any) {
        actorInfo["height"] = Int(heightTextField.text!)
        actorInfo["bloodType"] = pickerData[bloodTypePickerView.selectedRow(inComponent: 0)]
        if edit == false{
        performSegue(withIdentifier: "addActorSocialMediaSegue", sender: nil)
        } else {
            Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
            callback?(self.actorInfo)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddActorSocialMediaViewController
        nextVC.actorInfo = actorInfo
        nextVC.actor = actor
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}
