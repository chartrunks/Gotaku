//
//  MapViewController.swift
//  Gotaku
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    //var tennisBoys: [TennisBoy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tennisBoys = getAllTennisBoys()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //Already requested use
            setUp()
        } else {
            //Request use
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    //Runs once they give authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //updates to show where they are
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //Spawn a tennis boy
            
            //Annotation is image on top of map
            if let coord = self.manager.location?.coordinate{
                //let tennisBoy = self.tennisBoys[Int(arc4random_uniform(UInt32(self.tennisBoys.count)))]
                
                //let anno = TennisBoyAnnotation(coord: coord, tennisBoy: tennisBoy)
                
                //anno.coordinate.latitude += randomLat
                //anno.coordinate.longitude += randomLon
                //self.mapView.addAnnotation(anno)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Returns blue dot for location
        if annotation is MKUserLocation{
//            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
//            
//            annoView.image = UIImage(named: "tennisPlayer")
//            
//            var frame = annoView.frame
//            frame.size.height = 50
//            frame.size.width = 50
//            annoView.frame = frame
//            
//            return annoView
            return MKAnnotationView()
        }
        
        //Change pin to pic
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //let tennisBoy = (annotation as! TennisBoyAnnotation).tennisBoy
        
        //annoView.image = UIImage(named: tennisBoy.imageName!)
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    
    //Called everytime location manager sees movement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Only updates location in beginning
        if updateCount < 3{
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Do nothing if they click on the user image
        if view.annotation! is MKUserLocation {
            return
        }
        
        //Move to the location of the tennis boy they clicked on
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        
        //Set a timer to make sure the zoom finishes first
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
        }
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }

}
