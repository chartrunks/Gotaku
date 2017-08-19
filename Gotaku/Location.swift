//
//  Location.swift
//  Gotaku
//
//  Created by Mac on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import MapKit

class Location{
    var locID = ""
    var name = ""
    var description = ""
    var address = ""
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var typeImageName = ""
    var category = ""
    var times : [String] = []
    var websiteURL = ""
    var goodsTypes : [String] = []
    var pictureURLS : [String] = []
    var comments : [Comment] = []
    var lastUpdated = ""
    var relatedTitles : [String] = []
    var rating = 0.0
    var views = 0
    var ratings : [Double] = []
    var ratedUsers : [String] = []
    var prefecture = ""
}

