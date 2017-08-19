//
//  EventAnnotation.swift
//  Gotaku
//
//  Created by Mac on 6/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var event : Event
    var title : String?
    
    init(coord: CLLocationCoordinate2D, event: Event, title: String){
        self.coordinate = coord
        self.event = event
        self.title = title
    }
}

