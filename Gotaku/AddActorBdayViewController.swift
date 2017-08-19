//
//  AddActorBdayViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddActorBdayViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var strDate = ""
    
    var actorInfo : [String:Any] = [:]
    
    var actor = Actor()
    
    var callback : (([String:Any]) -> Void)?
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if actor.birthdate != ""{
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            datePicker.date = formatter.date(from: actor.birthdate)!
            actorInfo["birthdate"] = actor.birthdate
            actorInfo["age"] = actor.age
        }
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if strDate != ""{
            actorInfo["birthdate"] = strDate
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let now = Date()
            let birthday: Date = formatter.date(from: strDate)!
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            actorInfo["age"] = ageComponents.year!
            if edit == false{
                performSegue(withIdentifier: "addActorHeightBloodSegue", sender: nil)
            } else {
                Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
                callback?(self.actorInfo)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if edit == false{
                performSegue(withIdentifier: "addActorHeightBloodSegue", sender: nil)
            } else {
                Database.database().reference().child("actorInfo").child("actors").child(self.actorInfo["actorID"] as! String).setValue(self.actorInfo)
                callback?(self.actorInfo)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddActorHeightBloodTypeViewController
        nextVC.actorInfo = actorInfo
        nextVC.actor = actor
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func datePickerChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        
        strDate = dateFormatter.string(from: datePicker.date)
    }
}
