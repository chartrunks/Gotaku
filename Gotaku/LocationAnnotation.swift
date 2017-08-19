//
//  LocationAnnotation.swift
//  Gotaku
//
//  Created by Mac on 6/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var loc : Location
    var title : String?
    
    init(coord: CLLocationCoordinate2D, loc: Location, title: String){
        self.coordinate = coord
        self.loc = loc
        self.title = title
    }
}
