//
//  AddActorPastRoleTimesViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddActorPastRoleTimesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startEntered = false
    
    var endEntered = false
    
    var selectedLoc = ""
    
    var times : [String] = []
    
    var locNames : [String] = []
    
    var actorID = ""
    
    var newActors : [[String:String]] = []
    
    var oldActors : [String] = []
    
    var enteredGroups : [String:[String:String]] = [:]
    
    var enteredActors : [String:String] = [:]
    
    var enteredLocNames : [String] = []
    
    var roleInfo : [String:Any] = [:]
    
    var initialVC = ""
    
    var startDate = ""
    var endDate = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var locTextField: UITextField!
    
    @IBOutlet weak var addDateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        addDateButton.isEnabled = false
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        locTextField.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        Database.database().reference().child("eventInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            self.enteredLocNames = ((snapshot.value as! NSDictionary)["enteredLocationNames"] as! String).components(separatedBy: "%")
        })
    }
    
    func textFieldTapped(_ sender: UITextField){
        performSegue(withIdentifier: "searchSegue", sender: sender.tag)
    }
    
    func datePickerChanged(_ sender: UIDatePicker){
        if selectedLoc != "" && endEntered == false {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            if startEntered == false{
                startDate = dateFormatter.string(from: sender.date)
            } else {
                endDate = dateFormatter.string(from: sender.date)
            }
            addDateButton.isEnabled = true
        }
    }
    
    @IBAction func addDateTapped(_ sender: Any) {
        if startDate == ""{
            let alertVC = UIAlertController(title: "Missing Date", message: "You must enter a starting date. Please try again.", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(oKAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            if startEntered == false{
                startEntered = true
                dateLabel.text = "Ending Date"
                let alertVC = UIAlertController(title: "Ending Date", message: "You have entered a starting date of:\n\(startDate)\nPlease enter an ending date.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)            } else {
                if endDate == ""{
                    
                    let alertVC = UIAlertController(title: "Missing Date", message: "You must enter both a starting date and an ending date. Please try again.", preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(oKAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                } else {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateStyle = .short
                    let tempStartDate = dateFormatter.date(from: startDate)
                    let tempEndDate = dateFormatter.date(from: endDate)
                    if tempStartDate?.compare(tempEndDate!) == ComparisonResult.orderedAscending{
                        
                        times[locNames.index(of: selectedLoc)!] = "\(startDate) - \(endDate)"
                        endEntered = true
                        tableView.reloadData()
                        addDateButton.isEnabled = false
                        dateLabel.text = "Starting Date"
                        startDate = ""
                        endDate = ""
                    } else {
                        let alertVC = UIAlertController(title: "Incorrect Date Input", message: "The ending date must be after the starting date. Please try again.", preferredStyle: .alert)
                        let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertVC.addAction(oKAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        var timesDic : [String:String] = [:]
        
        var i = 0
        for loc in locNames{
            timesDic[loc] = times[i]
            i += 1
        }
        
        roleInfo["times"] = timesDic
        
        
        performSegue(withIdentifier: "addGoodsInfoSegue", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if locNames.count > 1 {
            return locNames.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if locNames.count >= 1{
            return locNames[section]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = times[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if times.count == 0{
            return 0
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            times.remove(at: indexPath.section)
            locNames.remove(at: indexPath.section)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGoodsInfoSegue"{
            let nextVC = segue.destination as! AddGoodsInfoViewController
            nextVC.roleInfo = roleInfo
            nextVC.newActors = newActors
            nextVC.oldActors = oldActors
            nextVC.enteredGroups = enteredGroups
            nextVC.enteredActors = enteredActors
            nextVC.initialVC = initialVC
            nextVC.enteredLocNames = enteredLocNames
        } else if segue.identifier == "searchSegue"{
            let nextVC = segue.destination as! SearchTable
            nextVC.searchArray = enteredLocNames
            nextVC.callback = { selection in
                self.locNames.append(selection)
                self.selectedLoc = selection
                self.tableView.reloadData()
                self.times.append("")
                self.startEntered = false
                self.endEntered = false
                if !self.enteredLocNames.contains(selection){
                    self.enteredLocNames.append(selection)
                }
            }
        }
    }
    
}
