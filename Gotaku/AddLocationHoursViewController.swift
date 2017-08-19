//
//  AddLocationHoursViewController.swift
//  Gotaku
//
//  Created by Mac on 6/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class AddLocationHoursViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var skipNextButton: UIBarButtonItem!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var initialVC = ""
    
    var days : [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var pickerData : [[String]] = []
    
    var hours : [String:String] = ["Sunday": "", "Monday": "", "Tuesday": "", "Wednesday": "", "Thursday": "", "Friday": "", "Saturday": ""]
    
    var locationInfo : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerData = [["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], ["00:00", "00:15", "00:30", "00:45", "01:00", "01:15", "01:30", "01:45", "02:00", "02:15", "02:30", "02:45", "03:00", "03:15", "03:30", "03:45", "04:00", "04:15", "04:30", "04:45", "05:00", "05:15", "05:30", "05:45", "06:00", "06:15", "06:30", "06:45", "07:00", "07:15", "07:30", "07:45", "08:00", "08:15", "08:30", "08:45", "09:00", "09:15", "09:30", "09:45", "10:00", "10:15", "10:30", "10:45", "11:00", "11:15", "11:30", "11:45","12:00", "12:15", "12:30", "12:45","13:00", "13:15", "13:30", "13:45","14:00", "14:15", "14:30", "14:45","15:00", "15:15", "15:30", "15:45","16:00", "16:15", "16:30", "16:45","17:00", "17:15", "17:30", "17:45","18:00", "18:15", "18:30", "18:45","19:00", "19:15", "19:30", "19:45","20:00", "20:15", "20:30", "20:45","21:00", "21:15", "21:30", "21:45","22:00", "22:15", "22:30", "22:45","23:00", "23:15", "23:30", "23:45", "24:00"], ["00:00", "00:15", "00:30", "00:45", "01:00", "01:15", "01:30", "01:45", "02:00", "02:15", "02:30", "02:45", "03:00", "03:15", "03:30", "03:45", "04:00", "04:15", "04:30", "04:45", "05:00", "05:15", "05:30", "05:45", "06:00", "06:15", "06:30", "06:45", "07:00", "07:15", "07:30", "07:45", "08:00", "08:15", "08:30", "08:45", "09:00", "09:15", "09:30", "09:45", "10:00", "10:15", "10:30", "10:45", "11:00", "11:15", "11:30", "11:45","12:00", "12:15", "12:30", "12:45","13:00", "13:15", "13:30", "13:45","14:00", "14:15", "14:30", "14:45","15:00", "15:15", "15:30", "15:45","16:00", "16:15", "16:30", "16:45","17:00", "17:15", "17:30", "17:45","18:00", "18:15", "18:30", "18:45","19:00", "19:15", "19:30", "19:45","20:00", "20:15", "20:30", "20:45","21:00", "21:15", "21:30", "21:45","22:00", "22:15", "22:30", "22:45","23:00", "23:15", "23:30", "23:45", "24:00"]]

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let i = indexPath.row
        if i == 0{
            cell.textLabel?.text = "Sunday: \(hours["Sunday"]!)"
        } else if i == 1{
            cell.textLabel?.text = "Monday: \(hours["Monday"]!)"
        } else if i == 2{
            cell.textLabel?.text = "Tuesday: \(hours["Tuesday"]!)"
        } else if i == 3{
            cell.textLabel?.text = "Wednesday: \(hours["Wednesday"]!)"
        } else if i == 4{
            cell.textLabel?.text = "Thursday: \(hours["Thursday"]!)"
        } else if i == 5{
            cell.textLabel?.text = "Friday: \(hours["Friday"]!)"
        } else if i == 6{
            cell.textLabel?.text = "Saturday: \(hours["Saturday"]!)"
        }
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        var index = 0
        var empty = true
        while index <= 6 && empty == true{
            if hours[days[index]] != ""{
             empty = false
            }
            index += 1
        }
        if empty == false{
        locationInfo["hours"] = hours
        }
        performSegue(withIdentifier: "addGoodsTypesSegue", sender: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let startDay = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        let endDay = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        let openTime = pickerData[2][pickerView.selectedRow(inComponent: 2)]
        let closeTime = pickerData[3][pickerView.selectedRow(inComponent: 3)]
        
        var startDayInt = Int(days.index(of: startDay)!)
        var endDayInt = Int(days.index(of: endDay)!)
        var contains : [String] = []
        if startDayInt == endDayInt{
            if hours[days[startDayInt]] != ""{
                contains.append(startDay)
            }
        } else if startDayInt < endDayInt{
            var index = startDayInt
            while index <= endDayInt{
                if hours[days[index]] != ""{
                    contains.append(days[index])
                }
                index += 1
            }
        } else{
            var index = startDayInt
            while index <= 6{
                if hours[days[index]] != ""{
                    contains.append(days[index])
                }
                index += 1
            }
            index = 0
            while index <= endDayInt{
                if hours[days[index]] != ""{
                    contains.append(days[index])
                }
                index += 1
            }
        }
        if contains.count == 0{
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let openTimeDate = formatter.date(from: openTime)
            let closeTimeDate = formatter.date(from: closeTime)
            if openTimeDate?.compare(closeTimeDate!) == .orderedAscending{
                
                if startDayInt == endDayInt{
                    hours[startDay] = "\(openTime) - \(closeTime)"
                    
                } else if startDayInt < endDayInt{
                    var index = startDayInt
                    while index <= endDayInt{
                        hours[days[index]] = "\(openTime) - \(closeTime)"
                            
                        index += 1
                    }
                } else{
                    var index = startDayInt
                    while index <= 6{
                        hours[days[index]] = "\(openTime) - \(closeTime)"
                        index += 1
                    }
                    index = 0
                    while index <= endDayInt{
                        hours[days[index]] = "\(openTime) - \(closeTime)"
                        index += 1
                    }
                }
                tableView.reloadData()
            } else {
                print("error: close time should be later than open time")
            }
            
        } else {
            print("error: contains times for date already")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddShopGoodsTypesViewController
        nextVC.locationInfo = locationInfo
        nextVC.initialVC = initialVC
    }
    
}
