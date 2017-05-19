//
//  ViewController.swift
//  TP5
//
//  Created by m2sar on 30/03/17.
//  Copyright © 2017 m2sar. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var Contact: UIBarButtonItem!
    
    let MAPS_URL:URL? = URL(string: "http://maps.apple.com/?q=Yosemite")
    
    @IBOutlet weak var MAP_VIEW: MKMapView!
    
    @IBAction func dropPin(_ sender: AnyObject) {
        MAP_VIEW.addAnnotation(Pin(incl2d:MAP_VIEW.centerCoordinate))
    }

    /*@IBAction func openMapsAppWithURL(sender: UIButton) {
        if MAPS_URL != nil {
            UIApplication.shared.open(MAPS_URL!, options:[:], completionHandler:nil)
        }
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        MAP_VIEW.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
        let width = 1000.0 // meters
        let height = 1000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
}

