//
//  ViewAllShopsFoodViewController.swift
//  Gotaku
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class ViewAllShopsFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationType = ""
    
    var regions = ["Hokkaido", "Tohoku", "Kanto", "Chubu", "Kansai", "Chugoku", "Shikoku", "Kyushu", "Okinawa", "Abroad"]
    
    var hokkaido : [[Location]] = [[]]
    var tohoku : [[Location]] = [[], [], [], [], [], []]
    var kanto : [[Location]] = [[], [], [], [], [], [], []]
    var chubu : [[Location]] = [[], [], [], [], [], [], [], [], []]
    var kansai : [[Location]] = [[], [], [], [], [], [], []]
    var chugoku : [[Location]] = [[], [], [], [], []]
    var shikoku : [[Location]] = [[], [], [], []]
    var kyushu : [[Location]] = [[], [], [], [], [], [], []]
    var okinawa : [[Location]] = [[]]
    var abroad : [[Location]] = [[], [], [], [], [], []]
    
    
    var prefectures =  [["Hokkaido"], ["Akita", "Aomori", "Fukushima", "Iwate", "Miyagi", "Yamagata"], ["Chiba", "Gunma", "Ibaraki", "Kanagawa", "Saitama", "Tochigi", "Tokyo"], ["Aichi", "Fukui", "Gifu", "Ishikawa", "Nagano", "Niigata", "Shizuoka", "Toyama", "Yamanashi"], ["Hyogo", "Kyoto", "Mie", "Nara", "Osaka", "Shiga", "Wakayama"], ["Hiroshima", "Okayama", "Shimane", "Tottori", "Yamaguchi"], ["Ehime", "Kagawa", "Kochi", "Tokushima"], ["Fukuoka", "Kagoshima", "Kumamoto", "Miyazaki", "Nagasaki", "Oita", "Saga"], ["Okinawa"], ["China", "Hong Kong", "Taiwan", "Thailand", "U.S.", "Other"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("locationInfo").child("locations").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let location = Location()
            //All locations must have the following
            let title = (snapshot.value as! NSDictionary)["name"] as! String
            let category = (snapshot.value as! NSDictionary)["category"] as! String
            let locID = (snapshot.value as! NSDictionary)["locID"] as! String
            location.name = title
            location.typeImageName = (snapshot.value as! NSDictionary)["typeImageName"] as! String
            location.locID = locID
            location.address = (snapshot.value as! NSDictionary)["address"] as! String
            location.rating = (snapshot.value as! NSDictionary)["rank"]
                as! Double
            location.lastUpdated = (snapshot.value as! NSDictionary)["lastUpdated"] as! String
            location.views = (snapshot.value as! NSDictionary)["views"] as! Int
            location.category = category
            location.prefecture = (snapshot.value as! NSDictionary)["prefecture"] as! String
            
            //Optional values
            if snapshot.hasChild("description"){
                location.description = (snapshot.value as! NSDictionary)["description"] as! String
            }
            if snapshot.hasChild("website"){
                location.websiteURL = (snapshot.value as! NSDictionary)["website"] as! String
            }
            
            //Optional values that should be turned into a String Array
            if snapshot.hasChild("pictureURLS"){
                location.pictureURLS = ((snapshot.value as! NSDictionary)["pictureURLS"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("times"){
                location.times = ((snapshot.value as! NSDictionary)["times"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("relatedTitles"){
                location.relatedTitles = ((snapshot.value as! NSDictionary)["relatedTitles"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("ratings"){
                let strArray : [String] = ((snapshot.value as! NSDictionary)["ratings"] as! String).components(separatedBy: " ")
                
                location.ratings = strArray.map{ Double($0)!}
            }
            if snapshot.hasChild("ratedUsers"){
                location.ratedUsers = ((snapshot.value as! NSDictionary)["ratedUsers"] as! String).components(separatedBy: " ")
            }
            
            let coord = CLLocationCoordinate2D(latitude: (snapshot.value as! NSDictionary)["coordLat"] as! Double, longitude: (snapshot.value as! NSDictionary)["coordLon"] as! Double)
            location.coordinate = coord
            
            if location.category == self.locationType{
                
                if location.prefecture == "Hokkaido"{
                    self.hokkaido[0].append(location)
                    self.hokkaido[0] = self.hokkaido[0].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[1].contains(location.prefecture){
                    let index = self.prefectures[1].index(of: location.prefecture)
                    self.tohoku[index!].append(location)
                    self.tohoku[index!] = self.tohoku[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[2].contains(location.prefecture){
                    let index = self.prefectures[2].index(of: location.prefecture)
                    self.kanto[index!].append(location)
                    self.kanto[index!] = self.kanto[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[3].contains(location.prefecture){
                    let index = self.prefectures[3].index(of: location.prefecture)
                    self.chubu[index!].append(location)
                    self.chubu[index!] = self.chubu[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[4].contains(location.prefecture){
                    let index = self.prefectures[4].index(of: location.prefecture)
                    self.kansai[index!].append(location)
                    self.kansai[index!] = self.kansai[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[5].contains(location.prefecture){
                    let index = self.prefectures[5].index(of: location.prefecture)
                    self.chugoku[index!].append(location)
                    self.chugoku[index!] = self.chugoku[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[6].contains(location.prefecture){
                    let index = self.prefectures[6].index(of: location.prefecture)
                    self.shikoku[index!].append(location)
                    self.shikoku[index!] = self.shikoku[index!].sorted(by: { $0.name < $1.name})
                } else if self.prefectures[7].contains(location.prefecture){
                    let index = self.prefectures[7].index(of: location.prefecture)
                    self.kyushu[index!].append(location)
                    self.kyushu[index!] = self.kyushu[index!].sorted(by: { $0.name < $1.name})
                } else if location.prefecture == "Okinawa"{
                    self.okinawa[0].append(location)
                    self.okinawa[0] = self.okinawa[0].sorted(by: { $0.name < $1.name})
                } else{
                    if self.prefectures[9].contains(location.prefecture){
                        let index = self.prefectures[9].index(of: location.prefecture)
                        self.abroad[index!].append(location)
                        self.abroad[index!] = self.abroad[index!].sorted(by: { $0.name < $1.name})
                    } else{
                        self.abroad[self.prefectures[9].count - 1].append(location)
                    }
                }
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = regions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        if i == 0 || i == 8{
            performSegue(withIdentifier: "viewAllLocationsInPrefectureSegue", sender: i)
        } else if (i > 0 && i < 8) || i == 9 {
            performSegue(withIdentifier: "viewAllLocationsPrefecturesSegue", sender: i)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewAllLocationsPrefecturesSegue"{
            let i = sender as! Int
            let nextVC = segue.destination as! ViewAllShopsFoodPrefecturesViewController
            if i == 1{
                nextVC.region = "Tohoku"
                nextVC.locations = tohoku
                nextVC.prefectures = prefectures[1]
            } else if i == 2{
                nextVC.region = "Kanto"
                nextVC.locations = kanto
                nextVC.prefectures = prefectures[2]
            } else if i == 3{
                nextVC.region = "Chubu"
                nextVC.locations = chubu
                nextVC.prefectures = prefectures[3]
            } else if i == 4{
                nextVC.region = "Kansai"
                nextVC.locations = kansai
                nextVC.prefectures = prefectures[4]
            } else if i == 5{
                nextVC.region = "Chugoku"
                nextVC.locations = chugoku
                nextVC.prefectures = prefectures[5]
            } else if i == 6{
                nextVC.region = "Shikoku"
                nextVC.locations = shikoku
                nextVC.prefectures = prefectures[6]
            } else if i == 7 {
                nextVC.region = "Kyushu"
                nextVC.locations = kyushu
                nextVC.prefectures = prefectures[7]
            } else if i == 9{
                nextVC.region = "Abroad"
                nextVC.locations = abroad
                nextVC.prefectures = prefectures[9]
            }
        } else if segue.identifier == "viewAllLocationsInPrefectureSegue"{
            let i = sender as! Int
            let nextVC = segue.destination as! ViewAllShopsFoodInPrefectureViewController
            if i == 0{
                nextVC.locations = hokkaido[0]
                nextVC.prefecture = "Hokkaido"
            } else if i == 8{
                nextVC.locations = okinawa[0]
                nextVC.prefecture = "Okinawa"
            }
        } else if segue.identifier == "viewMapSegue"{
            let nextVC = segue.destination as! MapViewController
            nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.1590, longitude: 137.8829)
            nextVC.regionInfo["height"] = 2000000.0
            nextVC.regionInfo["width"] = 2000000.0
        }
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        performSegue(withIdentifier: "viewMapSegue", sender: nil)
    }
    
}
