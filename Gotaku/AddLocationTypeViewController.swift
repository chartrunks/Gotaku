//
//  AddLocationTypeViewController.swift
//  Gotaku
//
//  Created by Mac on 6/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class AddLocationTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var locationInfo : [String:Any] = [:]
    
    var pickerData : [String] = []
    
    var currentLocCoord = CLLocationCoordinate2D()
    
    var initialVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerData = ["2.5D Show", "Attraction", "Food/Drink", "Event", "Shop"]
    }

    @IBAction func nextTapped(_ sender: Any) {
        let category = pickerData[pickerView.selectedRow(inComponent: 0)]
        
        if category == "2.5D Show"{
            locationInfo["category"] = "twoPointFive"
            let alertVC = UIAlertController(title: "Past/Current/Future Event", message: "Is this a past event? Or is it taking place now or in the future? Make sure to tap the appropriate button!", preferredStyle: .alert)
            let pastAction = UIAlertAction(title: "Past Event", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "addLocationInfoSegue", sender: nil)
            })
            let currentFutureAction = UIAlertAction(title: "Current/Future Event", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "addLocationSegue", sender: nil)
            })
            alertVC.addAction(pastAction)
            alertVC.addAction(currentFutureAction)
            self.present(alertVC, animated: true, completion: nil)
        } else if category == "Food/Drink"{
            locationInfo["category"] = "food"
        } else{
            locationInfo["category"] = category.lowercased()
        }
        performSegue(withIdentifier: "addLocationSegue", sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue"{
        let nextVC = segue.destination as! AddLocationCoordinatesViewController
        nextVC.locationInfo = locationInfo
        nextVC.currentLocCoord = currentLocCoord
        nextVC.initialVC = initialVC
        } else if segue.identifier == "addLocationInfoSegue"{
            let nextVC = segue.destination as! AddLocationViewController
            nextVC.locationInfo = locationInfo
            nextVC.initialVC = initialVC
        }
    }
    

}
