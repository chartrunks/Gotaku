//
//  ViewRoleInfoViewController.swift
//  Gotaku
//
//  Created by Mac on 7/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ViewRoleInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var roles : [Event] = []
    
    var actorID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRoleSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let role = roles[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        var index = 0
        var roleStr = "• \(role.name) ("
            var timeArr : [String] = []
            for (loc, times) in role.times{
                for time in role.times[loc]!{
                    timeArr.append(time)
                }
            }
            var arrayCount = timeArr.count
            var timeDateArr : [Date] = []
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
        if timeArr[0].contains(":"){
            dateFormatter.timeStyle = .short
        }
            for time in timeArr{
                timeDateArr.append(dateFormatter.date(from: time)!)
            }
            timeDateArr = timeDateArr.sorted(by: { $0.timeIntervalSince1970 < $1.timeIntervalSince1970})
            var i = 0
            for date in timeDateArr{
                timeArr[i] = dateFormatter.string(from: date)
                i += 1
            }
            if arrayCount == 1{
                roleStr.append(timeArr[0].components(separatedBy: ", ")[0])
            } else if arrayCount > 1{
                let start = timeArr[0].components(separatedBy: ", ")[0]
                let end = timeArr[timeArr.count - 1].components(separatedBy: ", ")[0]
                roleStr.append("\(start) - \(end)")
            }
            
            for (_, cast) in role.cast{
                for (castActor, role) in cast{
                    if castActor == actorID{
                        roleStr.append(") - \(role)")
                    }
                }
            
        }
        cell.textLabel?.text = roleStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "addRoleSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoleSegue"{
           let nextVC = segue.destination as! ViewLocationViewController
            nextVC.event = roles[sender as! Int]
        } else if segue.identifier == "addRoleSegue"{
           let nextVC = segue.destination as! AddLocationCoordinatesViewController
            nextVC.locationInfo["category"] = "twoPointFive"
        }
    }

}
