//
//  ViewAllEventsShowsViewController.swift
//  Gotaku
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class ViewAllEventsShowsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var eventType = ""
    
    var events : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("eventInfo").child("events").observe(.childAdded, with: { (snapshot) in
            
            let category = (snapshot.value as! NSDictionary)["category"] as! String
            if category == self.eventType{
            let event = Event()
            //All locations must have the following
            let title = (snapshot.value as! NSDictionary)["name"] as! String
            
            let eventID = (snapshot.value as! NSDictionary)["eventID"] as! String
            event.name = title
            event.eventID = eventID
            
            event.rating = (snapshot.value as! NSDictionary)["rank"]
                as! Double
            event.lastUpdated = (snapshot.value as! NSDictionary)["lastUpdated"] as! String
            event.views = (snapshot.value as! NSDictionary)["views"] as! Int
            event.category = category
            event.active = (snapshot.value as! NSDictionary)["active"] as! Int
            
            //Optional values
            if snapshot.hasChild("address"){
                event.address = ((snapshot.value as! NSDictionary)["address"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("description"){
                event.description = (snapshot.value as! NSDictionary)["description"] as! String
            }
            if snapshot.hasChild("website"){
                event.websiteURL = (snapshot.value as! NSDictionary)["website"] as! String
            }
            if snapshot.hasChild("goodsURL"){
                event.goodsURL = (snapshot.value as! NSDictionary)["goodsURL"] as! String
            }
            if snapshot.hasChild("goodsDescrip"){
                event.goodsDescrip = (snapshot.value as! NSDictionary)["goodsDescrip"] as! String
            }
            
            //Optional values that should be turned into a String Array
            if snapshot.hasChild("pictureURLS"){
                event.pictureURLs = ((snapshot.value as! NSDictionary)["pictureURLs"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("times"){
                var timeDicArray : [String: [String]] = [:]
                let timeDic = (snapshot.value as! NSDictionary)["times"] as! [String:String]
                for (loc, times) in timeDic{
                    timeDicArray[loc] = times.components(separatedBy: "~")
                }
                event.times = timeDicArray
            }
            
            if snapshot.hasChild("ratings"){
                let strArray : [String] = ((snapshot.value as! NSDictionary)["ratings"] as! String).components(separatedBy: " ")
                
                event.ratings = strArray.map{ Double($0)!}
            }
            if snapshot.hasChild("ratedUsers"){
                event.ratedUsers = ((snapshot.value as! NSDictionary)["ratedUsers"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("cast"){
                event.cast = (snapshot.value as! NSDictionary)["cast"] as! [String: [String:String]]
            }
            
            if snapshot.hasChild("coordLat"){
                var coords : [CLLocationCoordinate2D] = []
                var coordLats : [Double] = []
                var coordLons : [Double] = []
                let coordLatsStr : [String] = ((snapshot.value as! NSDictionary)["coordLat"] as! String).components(separatedBy: " ")
                let coordLonsStr : [String] = ((snapshot.value as! NSDictionary)["coordLon"] as! String).components(separatedBy: " ")
                
                for str in coordLatsStr{
                    coordLats.append(Double(str)!)
                }
                
                for str in coordLonsStr{
                    coordLons.append(Double(str)!)
                    
                }
                var index = 0
                while index < coordLats.count{
                    let coord = CLLocationCoordinate2D(latitude: coordLats[index], longitude: coordLons[index])
                    coords.append(coord)
                    index += 1
                }
                event.coordinates = coords
            }
            self.events.append(event)
            self.events = self.events.sorted { $0.name < $1.name }
            self.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewEventSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = events[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ViewLocationViewController
        nextVC.event = events[sender as! Int]
    }

}
