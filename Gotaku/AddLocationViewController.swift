//
//  AddLocationViewController.swift
//  Gotaku
//
//  Created by Mac on 6/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var websiteTextField: UITextField!
    
    var locationInfo : [String:Any] = [:]
    
    var enteredNames : [String] = []
    
    var currentLocCoord = CLLocationCoordinate2D()
    
    var initialVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationInfo["category"] as! String == "twoPointFive"{
            Database.database().reference().child("eventInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                self.enteredNames = ((snapshot.value as! NSDictionary)["enteredTwoPointFive"] as! String).components(separatedBy: "%")
            })
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if self.nameTextField!.text == ""{
            let alertVC = UIAlertController(title: "Missing Name", message: "Please enter a name.", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(oKAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            enteredNames.append(self.nameTextField.text!)
            Database.database().reference().child("eventInfo").child("enteredTwoPointFive").setValue(enteredNames.joined(separator: "%"))
            
            self.locationInfo["name"] = self.nameTextField.text
            
            self.locationInfo["website"] = self.websiteTextField.text
            if locationInfo["category"] as! String == "twoPointFive"{
            performSegue(withIdentifier: "addRolesSegue", sender: nil)
            } else {
            performSegue(withIdentifier: "addLocationHoursSegue", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addLocationHoursSegue"{
            let nextVC = segue.destination as! AddLocationHoursViewController
            nextVC.locationInfo = locationInfo
        nextVC.initialVC = initialVC
    } else if segue.identifier == "addRolesSegue"{
        let nextVC = segue.destination as! AddActorRoleViewController
        nextVC.roleInfo = locationInfo
        nextVC.initialVC = initialVC
        
    } else if segue.identifier == "searchSegue"{
    
    }
    }
}
