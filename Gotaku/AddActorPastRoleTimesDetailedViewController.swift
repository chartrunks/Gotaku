//
//  AddActorPastRoleTimesDetailedViewController.swift
//  Gotaku
//
//  Created by Mac on 6/18/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddActorPastRoleTimesDetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedLoc = ""
    
    var actorID = ""
    
    var times : [[Date]] = []
    
    var locNames : [String] = []
    
    var newActors : [[String:String]] = []
    
    var oldActors : [String] = []
    
    var enteredGroups : [String:[String:String]] = [:]
    
    var enteredActors : [String:String] = [:]
    
    var enteredLocNames : [String] = []
    
    var roleInfo : [String:Any] = [:]
    
    var initialVC = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var locTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        addButton.isEnabled = false
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        locTextField.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        Database.database().reference().child("eventInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            self.enteredLocNames = ((snapshot.value as! NSDictionary)["enteredLocationNames"] as! String).components(separatedBy: "%")
        })
        
    }

    func textFieldTapped(_ sender: UITextField){
        performSegue(withIdentifier: "searchSegue", sender: sender.tag)
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
        dateFormatter.timeStyle = .short
        
        cell.textLabel?.text = dateFormatter.string(from: times[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if times.count == 0{
            return 0
        } else{
        return times[section].count
        }
    }

    func datePickerChanged(_ sender: UIDatePicker){
        if selectedLoc != ""{
        addButton.isEnabled = true
        }
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: sender.date)
        let year = components.year
        print(year!)
        print(Int(yearTextField.text!)!)
        if year! != (Int(yearTextField.text!)!){
            yearTextField.text = "\(year!)"
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addGoodsInfoSegue", sender: nil)
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        times[times.count - 1].append(datePicker.date)
        times[times.count - 1] = times[times.count - 1].sorted(by: { $0.timeIntervalSince1970 < $1.timeIntervalSince1970})
        addButton.isEnabled = false
        tableView.reloadData()
    }
    
    @IBAction func setYearTapped(_ sender: Any) {
        if Int(yearTextField.text!) == nil{
            let alertVC = UIAlertController(title: "Incorrect Input", message: "The year must be a number. Please try again.", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(oKAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let year = Int(yearTextField.text!)!
            if year < 2000 || year > 2025{
                let alertVC = UIAlertController(title: "Incorrect Input", message: "You must enter a year between 2000 and 2025. Please try again.", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(oKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                let calendar = NSCalendar.current
                var components = calendar.dateComponents([.day, .month, .year], from: datePicker.date)
                components.setValue(1, for: .day)
                components.setValue(7, for: .month)
                components.setValue(year, for: .year)
                datePicker.setDate(calendar.date(from: components)!, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            times[indexPath.section].remove(at: indexPath.row)
            if times[indexPath.section].count == 0{
                times.remove(at: indexPath.section)
                locNames.remove(at: indexPath.section)
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGoodsInfoSegue"{
        let nextVC = segue.destination as! AddGoodsInfoViewController
        nextVC.roleInfo = roleInfo
        nextVC.times = times
        nextVC.locNames = locNames
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
                self.times.append([])
                self.selectedLoc = selection
                self.tableView.reloadData()
                if !self.enteredLocNames.contains(selection){
                    self.enteredLocNames.append(selection)
                }
            }
        }
    }
    
}
