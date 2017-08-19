//
//  AddLocationCoordinatesViewController.swift
//  Gotaku
//
//  Created by Mac on 6/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class AddLocationCoordinatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var initialVC = ""
    
    var past = false
    
    var locationInfo : [String:Any] = [:]
    
    var locationNames : [String] = []
    
    var locations : [CLLocationCoordinate2D] = []
    
    var manager = CLLocationManager()
    
    @IBOutlet weak var currentLoc: UIButton!
    
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var addLocButton: UIButton!
    
    @IBOutlet weak var locNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var currentLocCoord = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        currentLoc.isEnabled = false
        searchButton.isEnabled = false
        addLocButton.isEnabled = false
        locNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if past == true{
            searchButton.isHidden = true
            currentLoc.isHidden = true
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        addLocButton.isEnabled = true
    }
    
    @IBAction func currentLocTapped(_ sender: Any) {
        currentLoc.isEnabled = false
        searchButton.isEnabled = false
        
        if currentLocCoord.latitude == 0.0 && currentLocCoord.longitude == 0.0{
            if let coord = manager.location?.coordinate {
                if !(locationInfo["category"] as! String == "twoPointFive"){
                    locationInfo["coordLat"] = coord.latitude
                    locationInfo["coordLon"] = coord.longitude
                } else {
                    if locationInfo["coordLat"] == nil && locationInfo["coordLon"] == nil{
                    locationInfo["coordLat"] = "\(coord.latitude)"
                    locationInfo["coordLon"] = "\(coord.longitude)"
                    } else{
                        var latStr : String = self.locationInfo["coordLat"] as! String
                        latStr = latStr + " \(coord.latitude)"
                        self.locationInfo["coordLat"] = latStr
                        var lonStr : String = self.locationInfo["coordLon"] as! String
                        lonStr = lonStr + " \(coord.longitude)"
                        self.locationInfo["coordLon"] = lonStr
                    }
                }
                locations.append(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
            }
        }
        else{
        if !(locationInfo["category"] as! String == "twoPointFive"){
        locationInfo["coordLat"] = currentLocCoord.latitude
        locationInfo["coordLon"] = currentLocCoord.longitude
        } else {
            if locationInfo["coordLat"] == nil && locationInfo["coordLon"] == nil{
                locationInfo["coordLat"] = "\(currentLocCoord.latitude)"
                locationInfo["coordLon"] = "\(currentLocCoord.longitude)"
            } else{
                var latStr : String = self.locationInfo["coordLat"] as! String
                latStr = latStr + " \(currentLocCoord.latitude)"
                self.locationInfo["coordLat"] = latStr
                var lonStr : String = self.locationInfo["coordLon"] as! String
                lonStr = lonStr + " \(currentLocCoord.longitude)"
                self.locationInfo["coordLon"] = lonStr
            }
        }
        locations.append(CLLocationCoordinate2D(latitude: currentLocCoord.latitude, longitude: currentLocCoord.longitude))
        }
        tableView.reloadData()
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        searchButton.isEnabled = false
        currentLoc.isEnabled = false
        performSegue(withIdentifier: "searchMapSegue", sender: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if locationInfo["coordLat"] != nil || (past == true){
            locationInfo["locationNames"] = locationNames
            performSegue(withIdentifier: "addLocationInfoSegue", sender: nil)
        } else {
            let alertVC = UIAlertController(title: "Location not selected", message: "Please enter the location by selecting 'Current Location' or 'Search Using Maps", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(oKAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func addLocNameTapped(_ sender: Any) {
        locationNames.append(locNameTextField.text!)
        if past == false{
        addLocButton.isEnabled = false
        }
        locNameTextField.text = ""
        currentLoc.isEnabled = true
        searchButton.isEnabled = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if !(locations.count < indexPath.section + 1){
        cell.textLabel?.text = "Latitude: \(locations[indexPath.section].latitude) Longitude: \(locations[indexPath.section].longitude)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return locationNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if locationNames.count == 0{
            return nil
        }
        return locationNames[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMapSegue"{
            let nextVC = segue.destination as! MapViewController
            nextVC.selecting = true
            nextVC.callback = { loc in
                if self.locationInfo["coordLat"] == nil{
                    if self.locationInfo["category"] as! String == "twoPointFive"{
                        self.locationInfo["coordLat"] = "\(loc["coordLat"]!)"
                    } else {
                    self.locationInfo["coordLat"] = loc["coordLat"]
                    }
                } else {
                    var latStr : String = self.locationInfo["coordLat"] as! String
                    latStr = latStr + " \(loc["coordLat"]!)"
                    self.locationInfo["coordLat"] = latStr
                }
                if self.locationInfo["coordLon"] == nil{
                    if self.locationInfo["category"] as! String == "twoPointFive"{
                        self.locationInfo["coordLon"] = "\(loc["coordLon"]!)"
                    } else {
                        self.locationInfo["coordLon"] = loc["coordLon"]
                    }

                } else {
                    var lonStr : String = self.locationInfo["coordLon"] as! String
                    lonStr = lonStr + " \(loc["coordLon"]!)"
                    self.locationInfo["coordLon"] = lonStr
                }
                if self.locationInfo["address"] == nil{
                    self.locationInfo["address"] = loc["address"]
                } else {
                    var addressStr : String = self.locationInfo["address"] as! String
                    addressStr = addressStr + "/\(loc["address"]!)"
                    self.locationInfo["address"] = addressStr
                }
                if self.locationInfo["prefecture"] == nil{
                    self.locationInfo["prefecture"] = loc["prefecture"]
                } else {
                    var prefectureStr : String = self.locationInfo["prefecture"] as! String
                    prefectureStr = prefectureStr + " \(loc["prefecture"]!)"
                    self.locationInfo["prefecture"] = prefectureStr
                }
                self.locations.append(CLLocationCoordinate2D(latitude: loc["coordLat"] as! CLLocationDegrees, longitude: loc["coordLon"] as! CLLocationDegrees))
                self.tableView.reloadData()
            }
        } else{
            let nextVC = segue.destination as! AddLocationViewController
            nextVC.locationInfo = locationInfo
            nextVC.initialVC = initialVC
        }
    }
}
