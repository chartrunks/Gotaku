//
//  MapViewController.swift
//  Gotaku
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var searchController : UISearchController!
    
    var updateCount = 0
    
    var selectedPin:MKPlacemark? = nil
    
    //var tennisBoys: [TennisBoy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up search controller
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController.searchResultsUpdater = locationSearchTable
        
        //Configure search bar and embed it in navigation bar
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for events/shops/cafes/etc..."
        navigationItem.titleView = searchController.searchBar
        
        //Makes so search bar isn't ever hidden and makes background dim
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        //Pass mapView to locationSearchTable
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        
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
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
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
            
            //Annotation is image on top of map
            if let coord = self.manager.location?.coordinate{
                //let tennisBoy = self.tennisBoys[Int(arc4random_uniform(UInt32(self.tennisBoys.count)))]
                
                //let anno = TennisBoyAnnotation(coord: coord, tennisBoy: tennisBoy)
                
                //anno.coordinate.latitude += randomLat
                //anno.coordinate.longitude += randomLon
                //self.mapView.addAnnotation(anno)
            }
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        //Returns blue dot for location
//        if annotation is MKUserLocation{
////            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
////            
////            annoView.image = UIImage(named: "tennisPlayer")
////            
////            var frame = annoView.frame
////            frame.size.height = 50
////            frame.size.width = 50
////            annoView.frame = frame
////            
////            return annoView
//            return nil
//        }
//        
//        //Change pin to pic
//        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
//        
//        //let tennisBoy = (annotation as! TennisBoyAnnotation).tennisBoy
//        
//        //annoView.image = UIImage(named: tennisBoy.imageName!)
//        
//        var frame = annoView.frame
//        frame.size.height = 50
//        frame.size.width = 50
//        annoView.frame = frame
//        
//        return annoView
//    }
    
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
            //Move to the location of the item they clicked on
            let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
            mapView.setRegion(region, animated: true)
            
            
            //Set a timer to make sure the zoom finishes first
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                //Explore nearby / Create annotation at location
            }
        }
        
        //Move to the location of the item they clicked on
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        
        //Set a timer to make sure the zoom finishes first
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            //Show info about that location
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }

}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: "getDirections", for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
