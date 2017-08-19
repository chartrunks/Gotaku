//
//  ViewAllShopsFoodPrefecturesViewController.swift
//  Gotaku
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class ViewAllShopsFoodPrefecturesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var region = ""
    var locations : [[Location]] = []
    var prefectures : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
            cell.textLabel?.text = prefectures[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefectures.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewAllLocationsInPrefectureSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAllLocationsInPrefectureSegue"{
        let nextVC = segue.destination as! ViewAllShopsFoodInPrefectureViewController
        nextVC.locations = locations[sender as! Int]
            nextVC.prefecture = prefectures[sender as! Int]
        } else if segue.identifier == "viewMapSegue"{
            let nextVC = segue.destination as! MapViewController
            if region == "Tohoku"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 39.0456, longitude: 140.8133)
                nextVC.regionInfo["width"] = 350000.0
                nextVC.regionInfo["height"] = 350000.0
                let locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                nextVC.locations = locs + locations[4] + locations[5]
            } else if region == "Kanto"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.7146, longitude: 139.6500)
                nextVC.regionInfo["width"] = 230000.0
                nextVC.regionInfo["height"] = 230000.0
                let locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                nextVC.locations = locs + locations[4] + locations[5] + locations[6]
            } else if region == "Chubu"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.1536, longitude: 137.8281)
                nextVC.regionInfo["width"] = 350000.0
                nextVC.regionInfo["height"] = 350000.0
                var locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                locs = locs + locations[4] + locations[5] + locations[6]
                nextVC.locations = locs + locations [7] + locations[8]
            } else if region == "Kansai"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.6672, longitude: 135.7825)
                nextVC.regionInfo["width"] = 270000.0
                nextVC.regionInfo["height"] = 270000.0
                let locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                nextVC.locations = locs + locations[4] + locations[5] + locations[6]
            } else if region == "Chugoku"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.9735, longitude: 132.7200)
                nextVC.regionInfo["width"] = 380000.0
                nextVC.regionInfo["height"] = 380000.0
                nextVC.locations = locations[0] + locations[1] + locations[2] + locations[3] + locations[4]
            } else if region == "Shikoku"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.5967, longitude: 133.5215)
                nextVC.regionInfo["width"] = 280000.0
                nextVC.regionInfo["height"] = 280000.0
                nextVC.locations = locations[0] + locations[1] + locations[2] + locations[3]
            } else if region == "Kyushu"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 32.5709, longitude: 130.7669)
                nextVC.regionInfo["width"] = 300000.0
                nextVC.regionInfo["height"] = 300000.0
                let locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                nextVC.locations = locs + locations[4] + locations[5] + locations[6]
            } else if region == "Abroad"{
                
                nextVC.regionInfo["region"] = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0000, 0.0000) , MKCoordinateSpanMake(180, 360) )
                let locs : [Location] = locations[0] + locations[1] + locations[2] + locations[3]
                nextVC.locations = locs + locations[4] + locations[5]
            }

        }
    }
        
    @IBAction func mapTapped(_ sender: Any) {
        performSegue(withIdentifier: "viewMapSegue", sender: nil)
                }

}
