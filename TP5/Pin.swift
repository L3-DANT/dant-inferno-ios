//
//  Pin.swift
//  TP5
//
//  Created by m2sar on 30/03/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation
import MapKit

class Pin:NSObject, MKAnnotation {
    public var coordinate:CLLocationCoordinate2D

    init(incl2d:CLLocationCoordinate2D) {
        coordinate = incl2d
    }
}
