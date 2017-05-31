//
//  AnnotationHistorique.swift
//  TP5
//
//  Created by m2sar on 04/05/2017.
//  Copyright © 2017 m2sar. All rights reserved.
//

import Foundation
import MapKit
class AnnotationHistorique :MKPointAnnotation{
    let posDate :Date
    
    init?(date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        if let dateForm = formatter.date(from: date) {
            self.posDate = dateForm
        } else {
            return nil
        }
        super.init()
    }
}
