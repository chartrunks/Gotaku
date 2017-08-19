//
//  MapViewController.swift
//  Gotaku
//
//  Created by Mac on 5/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var callback : (([String : Any]) -> Void)?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var locations : [Location] = []
    
    var allEvents : [Event] = []
    
    var searchController : UISearchController!
    
    var regionInfo : [String:Any] = [:]
    
    @IBOutlet weak var plusButton: UIButton!
    
    //For updating user location in beginning
    var updateCount = 0
    
    var selectedPin:MKPlacemark? = nil
    
    var selectedLoc : Location = Location()
    
    var selectedEvent : Event = Event()
    
    var shops : [Location] = []
    
    var food : [Location] = []
    
    var attractions : [Location] = []
    
    var twoPointFive : [Event] = []
    
    var events : [Event] = []
    
    //Tells whether they're selecting the location of a new location or just on the map
    var selecting = false
    
    var comments : [Comment] = []
    
    var currentLocID = ""
    
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
        
        locationSearchTable.handleMapSearchDelegate = self as HandleMapSearch
        
        if selecting == true{
            plusButton.isHidden = true
        }
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //Already requested use
            setUp()
        } else {
            //Request use
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    //Gets directions to location of pin they selected
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    //Shows info about pin they selected
    func getInfo(){
        if selectedLoc.locID != ""{
        Database.database().reference().child("locationInfo").child("locations").child(selectedLoc.locID).observeSingleEvent(of: .value, with: { (snapshot) in
            var views = (snapshot.value as! NSDictionary)["views"] as! Int
            views += 1
            Database.database().reference().child("locationInfo").child("locations").child(self.selectedLoc.locID).child("views").setValue(views)
        })
        } else{
            Database.database().reference().child("eventInfo").child("events").child(selectedEvent.eventID).observeSingleEvent(of: .value, with: { (snapshot) in
                var views = (snapshot.value as! NSDictionary)["views"] as! Int
                views += 1
                Database.database().reference().child("eventInfo").child("events").child(self.selectedEvent.eventID).child("views").setValue(views)
                })
        }
        performSegue(withIdentifier: "viewLocSegue", sender: nil)
    }
    
    func addLocation(){
    
        if let selectedPin = selectedPin {
        let address = selectedPin.title
        let lat = Double(selectedPin.coordinate.latitude)
        let lon = Double(selectedPin.coordinate.longitude)
            if let prefecture = selectedPin.administrativeArea{
                 let location = ["address": address!, "coordLat": lat, "coordLon": lon, "prefecture": prefecture] as [String : Any]
                callback?(location)
            } else{
            let location = ["address": address!, "coordLat": lat, "coordLon": lon] as [String : Any]
                callback?(location)
            }
            
            
            //go back to the previous view controller
            self.navigationController?.popViewController(animated: true)
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
        
        if regionInfo.count == 0{
        //updates to show where they are
        manager.startUpdatingLocation()
        } else if regionInfo.count == 1{
            let region = regionInfo["region"]
            mapView.setRegion(region as! MKCoordinateRegion, animated: false)
        } else {
            let region = MKCoordinateRegionMakeWithDistance(regionInfo["coordinate"] as! CLLocationCoordinate2D, regionInfo["height"] as! CLLocationDistance, regionInfo["width"] as! CLLocationDistance)
            mapView.setRegion(region, animated: false)
        }
        
        //Load all annogations
        if selecting == false{
            addAnnotations()
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if selecting == false{
            
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
                return nil
            }
            
            //Change pin to pic
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if annotation.isMember(of: LocationAnnotation.self){
            let location = (annotation as! LocationAnnotation).loc
                
            annoView.image = UIImage(named: location.category)
                
                 selectedPin = MKPlacemark(coordinate: location.coordinate)
                
            } else {
                let event = (annotation as! EventAnnotation).event
                
                annoView.image = UIImage(named: event.category)
                
                selectedPin = MKPlacemark(coordinate: event.coordinates[0])
            }
            
           
            
            var frame = annoView.frame
            frame.size.height = 20
            frame.size.width = 20
            annoView.frame = frame
            
            annoView.canShowCallout = true
            annoView.isEnabled = true
            
            let smallSquare = CGSize(width: 30, height: 30)
            let dirButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            let infoButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            
            dirButton.setImage(UIImage(named: "car"), for: .normal)
            dirButton.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
            annoView.leftCalloutAccessoryView = dirButton
            
            infoButton.setImage(UIImage(named: "info"), for: .normal)
            infoButton.addTarget(self, action: #selector(MapViewController.getInfo),for: .touchUpInside)
            annoView.rightCalloutAccessoryView = infoButton
            return annoView
        } else {
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            //Make pin with button and label for selecting
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                button.setImage(UIImage(named: "check"), for: .normal)
                button.addTarget(self, action: #selector(MapViewController.addLocation), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
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
            //Move to the location of the item they clicked on
            let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
            mapView.setRegion(region, animated: true)
            
            
            //Set a timer to make sure the zoom finishes first
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                //Explore nearby / Create annotation at location
            }
        }
        if let anno = view.annotation as? LocationAnnotation{
    selectedLoc = anno.loc
        }
        if let anno = view.annotation as? EventAnnotation{
            selectedEvent = anno.event
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
    
    
    func addAnnotations(){
        
        if locations.count == 0 {
            
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
            if location.category == "shop"{
                if self.shops.count == 0{
                    self.shops.append(location)
                    print(location.name)
                } else if location.name != self.shops[self.shops.count - 1].name{
                self.shops.append(location)
                print(location.name)
                }
            }
            let anno = LocationAnnotation(coord: coord, loc: location, title: title)
            self.mapView.addAnnotation(anno)
        })
            
            Database.database().reference().child("eventInfo").child("events").observe(.childAdded, with: { (snapshot) in
                
                
                let event = Event()
                //All locations must have the following
                let title = (snapshot.value as! NSDictionary)["name"] as! String
                let category = (snapshot.value as! NSDictionary)["category"] as! String
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
                for coord in event.coordinates{
                    let anno = EventAnnotation(coord: coord, event: event, title: title)
                    self.mapView.addAnnotation(anno)
                }
                
            })
        } else {
            for loc in locations{
                let anno = LocationAnnotation(coord: loc.coordinate, loc: loc, title: loc.name)
                self.mapView.addAnnotation(anno)
            }
        }
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "addLocationTypeSegue", sender: nil)
    }
    
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Couldn't click search bar unless I did this
        if segue.identifier == "viewLocSegue"{
            let nextVC = segue.destination as! ViewLocationViewController
            if selectedLoc.locID != ""{
            nextVC.loc = selectedLoc
            } else{
                nextVC.event = selectedEvent
            }
        } else {
            self.definesPresentationContext = false
            let nextVC = segue.destination as! AddLocationTypeViewController
            nextVC.currentLocCoord = (manager.location?.coordinate)!
            nextVC.initialVC = "map"
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
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

