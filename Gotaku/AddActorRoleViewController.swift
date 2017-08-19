//
//  AddActorRoleViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddActorRoleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var actorTextField: UITextField!
    @IBOutlet weak var characterTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var japanNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultSearchController:UISearchController? = nil
    
    var groupExists = false
    
    var enteredActors : [String:String] = [:]
    
    var enteredGroups : [String:[String:String]] = [:]
    
    var cast : [String:[String:String]] = [:]
    
    var characters : [[String]] = [[]]

    var newActors : [[String:String]] = []
    
    var oldActors : [String] = []
    
    var groups : [String] = []
    
    var actorID = ""
    
    var actorName = ""
    
    var roleInfo : [String:Any] = [:]
    
    var eventID = ""
    
    var initialVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        groupTextField.tag = 1
        actorTextField.tag = 2
        characterTextField.tag = 3
        
        groupTextField.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        actorTextField.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        //characterTextField.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        
        eventID = NSUUID().uuidString
        Database.database().reference().child("actorInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("enteredActors"){
                self.enteredActors = (snapshot.value as! NSDictionary)["enteredActors"] as! [String:String]
            }
            if snapshot.hasChild("enteredGroups"){
                self.enteredGroups = (snapshot.value as! NSDictionary)["enteredGroups"] as! [String: [String:String]]
                
            }
        })
    }
    
    func textFieldTapped(_ sender: UITextField){
        performSegue(withIdentifier: "searchSegue", sender: sender.tag)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        roleInfo["cast"] = cast
        roleInfo["eventID"] = eventID
        let alertVC = UIAlertController(title: "Choose the Date Type", message: "Select Start/End to enter just the starting and ending dates, or select Detailed to insert all dates and times.", preferredStyle: .alert)
        let detailedAction = UIAlertAction(title: "Detailed", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "addActorRoleDetailedDatesSegue", sender: nil)
            })
        let startEndAction = UIAlertAction(title: "Start/End", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "addActorRoleStartEndDatesSegue", sender: nil)
        })
        alertVC.addAction(detailedAction)
        alertVC.addAction(startEndAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func addGroupTapped(_ sender: Any) {
        groups.append(groupTextField.text!)
        enteredGroups[groupTextField.text!] = [:]
        cast[groupTextField.text!] = [:]
        tableView.reloadData()
    }
    
    @IBAction func addRoleTapped(_ sender: Any) {
        if groups.count == 0{
            groups.append("All Cast")
            cast["All Cast"] = [:]
        }
        cast[groups[groups.count - 1]]?[japanNameTextField.text!] = characterTextField.text
        if groupExists == false{
        enteredGroups[groups[groups.count - 1]]?[(japanNameTextField.text!)] = characterTextField.text
        }
        if enteredActors[japanNameTextField.text!] == nil{
            enteredActors[japanNameTextField.text!] = actorTextField.text
            let currentDateTime = Date()
            
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            newActors.append(["japaneseName":japanNameTextField.text!, "englishName" : actorTextField.text!, "actorID" : japanNameTextField.text!, "lastUpdated" : formatter.string(from: currentDateTime), "roles" : eventID])
        } else {
        oldActors.append(japanNameTextField.text!)
        }
        tableView.reloadData()
        actorTextField.text = ""
        japanNameTextField.text = ""
        characterTextField.text = ""
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.count == 0{
            return 0
        } else{
            return cast[groups[section]]!.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groups.count > 1 {
            return groups.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if groups.count >= 1{
            
       let frame: CGRect = tableView.frame
            
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
            
            let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 50))
            headerLabel.textColor = UIColor.black
            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
            headerView.addSubview(headerLabel)
            
            let selectBut: UIButton = UIButton(frame: CGRect(x: frame.size.width - 75, y: 0, width: 75, height: 50))
            selectBut.setTitle("Edit", for: .normal)
            selectBut.setTitleColor(UIColor.black, for: .normal)
            
            selectBut.addTarget(self, action: #selector(editTapped(_:)), for: .touchUpInside)
            headerView.addSubview(selectBut)
            return headerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func editTapped(_: UIButton){
        print("FUCK")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if groups.count >= 1{
            if groups[section].contains("(period)"){
                return groups[section].replacingOccurrences(of: "(period)", with: ".")
            }
            return groups[section]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let key = Array(cast[groups[indexPath.section]]!.keys)[indexPath.row]
        let value = Array(cast[groups[indexPath.section]]!.values)[indexPath.row]
        cell.textLabel?.text = "\(key) as \(value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            let name = Array(cast[groups[indexPath.section]]!.keys)[indexPath.row]
            if oldActors.contains(name){
            oldActors.remove(at: oldActors.index(of: name)!)
            } else {
                var index = 0
                var delIndex = 0
                for actor in newActors{
                    if actor["actorID"] == name{
                        delIndex = index
                    }
                    index += 1
                }
                newActors.remove(at: delIndex)
            }
            cast[groups[indexPath.section]]?.removeValue(forKey: name)
            if cast[groups[indexPath.section]]?.count == 0{
                groups.remove(at: indexPath.section)
            }
            
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addActorRoleDetailedDatesSegue"{
            let nextVC = segue.destination as! AddActorPastRoleTimesDetailedViewController
            nextVC.actorID = actorID
            nextVC.roleInfo = roleInfo
            nextVC.newActors = newActors
            nextVC.oldActors = oldActors
            nextVC.enteredActors = enteredActors
            nextVC.enteredGroups = enteredGroups
            nextVC.initialVC = initialVC
        } else if segue.identifier == "addActorRoleStartEndDatesSegue"{
            let nextVC = segue.destination as! AddActorPastRoleTimesViewController
            nextVC.actorID = actorID
            nextVC.roleInfo = roleInfo
            nextVC.newActors = newActors
            nextVC.oldActors = oldActors
            nextVC.enteredActors = enteredActors
            nextVC.enteredGroups = enteredGroups
            nextVC.initialVC = initialVC
        } else if segue.identifier == "searchSegue"{
            let nextVC = segue.destination as! SearchTable
            if sender as! Int == 1{
                nextVC.searchArray = Array(enteredGroups.keys)
                nextVC.callback = { selection in
                    if selection.contains("(period)"){
                        self.groupTextField.text = selection.replacingOccurrences(of: "(period)", with: ".")
                    } else {
                    self.groupTextField.text = selection
                    }
                    if self.enteredGroups[selection] != nil{
                        
                        self.cast[selection] = self.enteredGroups[selection]
                        self.groups.append(selection)
                        self.groupExists = true
                        for (actor, _) in self.enteredGroups[selection]!{
                            self.oldActors.append(actor)
                        }
                        self.tableView.reloadData()
                    } else {
                        self.groupExists = false
                        self.groups.append(selection)
                        self.enteredGroups[selection] = [:]
                        self.cast[selection] = [:]
                        self.tableView.reloadData()
                    }
                   
                }
            } else if sender as! Int == 2{
                nextVC.searchArray = Array(enteredActors.values)
                nextVC.callback = { selection in
                    self.actorTextField.text = selection
                    let keys = (self.enteredActors as NSDictionary).allKeys(for: selection) as! [String]
                    if keys.count > 0{
                    self.japanNameTextField.text = keys[0]
                    }
                }
            } else if sender as! Int == 3{
                
                nextVC.callback = { selection in
                    
                }
            }
            
        }
        
    }

}
