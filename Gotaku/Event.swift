//
//  Event.swift
//  Gotaku
//
//  Created by Mac on 6/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import MapKit

class Event{
    var eventID = ""
    var name = ""
    var description = ""
    var address : [String] = []
    var coordinates : [CLLocationCoordinate2D] = []
    var category = ""
    var active = 0
    var times : [String: [String]] = [:]
    var websiteURL = ""
    var goodsURL = ""
    var goodsDescrip = ""
    var pictureURLs : [String] = []
    var eventType = 0
    var comments : [Comment] = []
    var lastUpdated = ""
    var relatedTitles : [String] = []
    var rating = 0.0
    var cast : [String : [String : String]] = [:]
    var views = 0
    var ratings : [Double] = []
    var ratedUsers : [String] = []
}
