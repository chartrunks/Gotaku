//
//  AddGoodsInfoViewController.swift
//  Gotaku
//
//  Created by Mac on 6/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddGoodsInfoViewController: UIViewController {

    @IBOutlet weak var goodsURLTextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var roleInfo : [String:Any] = [:]
    
    var times : [[Date]] = []
    
    var locNames : [String] = []
    
    var newActors : [[String:String]] = []
    
    var oldActors : [String] = []
    
    var enteredGroups : [String:[String:String]] = [:]
    
    var enteredActors : [String:String] = [:]
    
    var enteredNames : [String] = []
    
    var enteredLocNames : [String] = []
    
    var initialVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Database.database().reference().child("eventInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("enteredTwoPointFive"){
                self.enteredNames = ((snapshot.value as! NSDictionary)["enteredTwoPointFive"] as! String).components(separatedBy: "%")
            }
            self.enteredNames.append(self.roleInfo["name"] as! String)
        })
        
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        if goodsURLTextField.text != "http://"{
            roleInfo["goodsURL"] = goodsURLTextField.text!
        }
        if textView.text != ""{
         roleInfo["goodsDescrip"] = textView.text!
        }
        let eventID = roleInfo["eventID"] as! String
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        roleInfo["views"] = 0
        roleInfo["lastUpdated"] = formatter.string(from: currentDateTime)
        roleInfo["rank"] = 0.0
        roleInfo["active"] = 1
        var timesDic : [String:String] = [:]
        
        if locNames.count > 0{
        for loc in locNames{
            var timeStr = ""
            let last = times[locNames.index(of: loc)!].count - 1
            var index = 0
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            for time in times[locNames.index(of: loc)!]{
                if index != last{
                    timeStr.append("\(dateFormatter.string(from: time))~")
                } else{
                    timeStr.append(dateFormatter.string(from: time))
                }
                index += 1
                
            }
            timesDic[loc] = timeStr
        }
        roleInfo["times"] = timesDic
        }
        
        Database.database().reference().child("eventInfo").child("events").child(eventID).setValue(roleInfo)
        for actor in oldActors{
            Database.database().reference().child("actorInfo").child("actors").child(actor).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("roles"){
                    var rolesStr = (snapshot.value as! NSDictionary)["roles"] as! String
                    rolesStr = rolesStr + (" \(eventID)")
                    Database.database().reference().child("actorInfo").child("actors").child(actor).child("roles").setValue(rolesStr)
                    Database.database().reference().child("actorInfo").child("actors").child(actor).child("lastUpdated").setValue(formatter.string(from: currentDateTime))
                } else{
                    Database.database().reference().child("actorInfo").child("actors").child(actor).child("roles").setValue(eventID)
                }
            })
            
        }
        
        for actor in newActors{
            Database.database().reference().child("actorInfo").child("actors").child(actor["actorID"]!).setValue(actor)
        }
        
        Database.database().reference().child("actorInfo").child("enteredActors").setValue(enteredActors)
        
        
        Database.database().reference().child("actorInfo").child("enteredGroups").setValue(enteredGroups)
        
        Database.database().reference().child("eventInfo").child("enteredTwoPointFive").setValue(enteredNames.joined(separator: "%"))
        Database.database().reference().child("eventInfo").child("enteredLocationNames").setValue(enteredLocNames.joined(separator: "%"))
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ViewAllActorsViewController.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }

        if initialVC == "map"{
            self.popBack(toControllerType: MapViewController.self)
        } else if initialVC == "actor"{
            self.popBack(toControllerType: ViewRoleInfoViewController.self)
        }
    }

    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
}
