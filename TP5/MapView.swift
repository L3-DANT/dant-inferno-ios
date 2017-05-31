//
//  ViewController.swift
//  TP5
//
//  Created by m2sar on 30/03/17.
//  Copyright © 2017 m2sar. All rights reserved.
//
import Foundation

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {
    //@IBOutlet weak var Contact: UIBarButtonItem!
    
    
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
    
    var currentLongitude : Double = 0.0
    var currentLatitude : Double = 0.0
    //var amis = Dictionary<Int,String>()
    var pins = Dictionary<String,CLLocationCoordinate2D>()
    var historique = Dictionary<String,CLLocationCoordinate2D>()
    var pinsHistorique = [AnnotationHistorique]()
    
    
    //if(dot1.latitude <= dot2.latitude + 0.0001 or dot1.latitude >= dot2.latitude - 0.0001
    //dot1.longitude
    func afficheAmi(list: Dictionary<String,CLLocationCoordinate2D>) {
        
        var selected = [MKPointAnnotation]()
        for annotation in MAP_VIEW.annotations{
            if annotation is AnnotationHistorique{
                
            }
            else if annotation is MKPointAnnotation{
                selected.append(annotation as! MKPointAnnotation)
            }
        }
        self.MAP_VIEW.removeAnnotations(selected)
        //print(MAP_VIEW.annotations)
        var pins = [MKPointAnnotation]()
        for (ami,pos) in list{
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = pos
            dropPin.title = ami
            pins.append(dropPin)
            
        }
        for pin in pins {
            MAP_VIEW.addAnnotation(pin)
        }
    }
    
    
    
    func majPositonAmi(request: URLRequest,ami: Contact, completion: @escaping (String)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            print(data as NSData) //<-`as NSData` is useful for debugging
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json)
                if let dictionary = json as? [String: Any] {
                    if let latitude = dictionary["latitude"] as? Double {
                        if let longitude = dictionary["longitude"] as? Double {
                            if let idUser = dictionary["id_user"] as? Int{
                                let newLoc = CLLocationCoordinate2DMake(latitude, longitude)
                                if ami.checkmark == true{
                                    self.pins[ami.login] = newLoc
                                }
                            }
                        }
                    }
                }//Why don't you use decoded JSON object? (`json` may not be a `String`)
            } catch {
                print("error serializing JSON: \(error)")
            }
            //Not sure what you mean with "i need to return the json as String"
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(responseString)
        }
        task.resume()
    }
    
    
    func afficheHistoriquePin(list: Dictionary<String,CLLocationCoordinate2D>){
        
        var selected = [MKPointAnnotation]()
        for annotation in MAP_VIEW.annotations{
            if annotation is AnnotationHistorique{
                selected.append(annotation as! MKPointAnnotation)
            }
            else if annotation is MKPointAnnotation{
                
            }
        }
        self.MAP_VIEW.removeAnnotations(selected)
        for (time,pos) in list{
            if let dropPin = AnnotationHistorique(date: time) {
                dropPin.coordinate = pos
                dropPin.title = time
                pinsHistorique.append(dropPin)
            }
            
        }
        var lim = pinsHistorique.count
        
        var j :Int
        var i = 0
        while i<lim {
            j=0
            while j<lim{
                if(i != j){
                    let iPin = pinsHistorique[i]
                    let jPin = pinsHistorique[j]
                    if(
                        (jPin.coordinate.latitude <= iPin.coordinate.latitude + 0.0003) &&
                            (jPin.coordinate.latitude >= iPin.coordinate.latitude - 0.0003)
                        ){
                        if(
                            (jPin.coordinate.longitude <= (iPin.coordinate.longitude + 0.0003)) &&
                                (jPin.coordinate.longitude >= iPin.coordinate.longitude-0.0003)){
                            let compareDatem = iPin.posDate.addingTimeInterval(-30.0 * 60.0)
                            let compareDateM = iPin.posDate.addingTimeInterval(30.0 * 60.0)
                            if(
                                (jPin.posDate <= compareDateM) &&
                                    (jPin.posDate >= compareDatem)){
                                pinsHistorique.remove(at: j)
                                lim = pinsHistorique.count
                                
                            }
                        }
                    }
                    
                }
                j = j + 1
            }
            i = i + 1
        }
        
        for pin in pinsHistorique{
            MAP_VIEW.addAnnotation(pin)
        }
    }
    func afficheHistorique(request: URLRequest, completion: @escaping (String)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            print(data as NSData) //<-`as NSData` is useful for debugging
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json)
                if let dictionary = json as? [[String: Any]] {
                    self.historique = Dictionary<String,CLLocationCoordinate2D>()
                    for i in 0..<dictionary.count{
                        if let latitude = dictionary[i]["latitude"] as? Double {
                            if let longitude = dictionary[i]["longitude"] as? Double {
                                if let date = dictionary[i]["dateString"] as? String{
                                    let newLoc = CLLocationCoordinate2DMake(latitude, longitude)
                                    self.historique[date] = newLoc
                                }
                            }
                        }
                    }
                    
                }//Why don't you use decoded JSON object? (`json` may not be a `String`)
            } catch {
                print("error serializing JSON: \(error)")
            }
            //Not sure what you mean with "i need to return the json as String"
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(responseString)
        }
        task.resume()
    }
    
    
    
    func SendPos(request: URLRequest, completion: @escaping (String)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            print(data as NSData) //<-`as NSData` is useful for debugging
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json)
            } catch {
                print("error serializing JSON: \(error)")
            }
            //Not sure what you mean with "i need to return the json as String"
            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(responseString)
        }
        task.resume()
    }
    func makeRequest(request: URLRequest,create: String, row: Int){
        
        
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in guard let data = data, error == nil else{
            print("error")
            return
            }
            
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            
            
            //print("DAAAAAAATTTTAAAAAAA: \(data as NSData)") //<-`as NSData` is useful for debugging
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                print("Json: \(json)")
                
                if create == "tabContact"{ //créer un tableau de contact contenant ce qui nous est renvoyé par l'API
                    
                    var dictionary2 = json as! [[String: Any]]//{
                    
                    if dictionary2.count >= 1{
                        
                        for index in 0...dictionary2.count - 1 {
                            
                                    if dictionary2[index]["idRecepteur"] as! Int != ConnectionView.idUser {
                                        ConnectionView.cellInfo = ConnectionView.cellInfo + [Contact(login: dictionary2[index]["pseudo"] as! String,checkmark: false, idRecepteur: dictionary2[index]["idRecepteur"] as! Int)]
                                        
                                        
                                    }else{
                                        
                                        ConnectionView.cellInfo = ConnectionView.cellInfo + [Contact(login: dictionary2[index]["pseudo"] as! String,checkmark: false, idRecepteur: dictionary2[index]["idDemandeur"] as! Int)]
                                        
                                        
                                    }
                                
                            
                            
                        }
                        
                    }
                }
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            //let responseString = String(data: data, encoding: .utf8) ?? ""
            //completion(???)
        }
        
        
        
        
        
        
        task.resume()
        
    }
    
    
    func runTime(){
        self.pins = Dictionary<String,CLLocationCoordinate2D>()
        for c in ConnectionView.cellInfo {
            print(c.login)
            majPositonAmi(request: URLRequest(url: URL(string: "http://178.62.22.140:8080/api/position/last?idUser=\(c.idRecepteur)")!),ami: c) { (result : String?) in
                if let result = result {
                    self.afficheAmi(list: self.pins)
                }
            }
            print("\(c.login) : \(c.checkmark)")
        }
        
        self.currentLatitude = MAP_VIEW.userLocation.coordinate.latitude
        self.currentLongitude = MAP_VIEW.userLocation.coordinate.longitude
        var url = "http://178.62.22.140:8080/api/position/add?idUser=14&latitude=\(self.currentLatitude)&longitude=\(self.currentLongitude)"
        var request = URLRequest(url: URL(string:url)!);
        request.httpMethod = "PUT";
        self.SendPos(request: request) { (result : String?) in
            if let result = result {
                print("********************")
                print(result)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.historique = Dictionary<String,CLLocationCoordinate2D>()
        self.pinsHistorique = [AnnotationHistorique]()
        if ConnectionView.Historique > 0{
            afficheHistorique(request: URLRequest(url: URL(string: "http://178.62.22.140:8080/api/position/list?idUser=\(ConnectionView.Historique)&since=1")!)) { (result : String?) in
                if let result = result {
                    self.afficheHistoriquePin(list: self.historique)
                }
            }
        }
        if ConnectionView.Historique < 0 {
            self.afficheHistoriquePin(list: self.historique)
        }
        var url = "http://178.62.22.140:8080/api/contact/liste/amis?idUser=\(ConnectionView.idUser)"
        var request = URLRequest(url: URL(string:url)!);
        self.makeRequest(request: request, create: "tabContact", row: 0)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MAP_VIEW.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        //MAP_VIEW.addAnnotation(Pin(incl2d:MAP_VIEW.centerCoordinate))
        MAP_VIEW.delegate = self
        /*let hist = AnnotationHistorique()
         hist.coordinate = CLLocationCoordinate2DMake(51.511039, -0.114198)
         hist.title = "test"
         MAP_VIEW.addAnnotation(hist)*/
        // Drop a pin
        
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTime), userInfo: nil, repeats: true)
        
        /*afficheHistorique(request: URLRequest(url: URL(string: "http://178.62.22.140:8080/api/position/list?idUser=1&since=1")!)) { (result : String?) in
         if let result = result {
         
         self.afficheHistoriquePin(list: self.historique)
         }
         }*/
        
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is AnnotationHistorique {
            return nil
        }
        if annotation is MKPointAnnotation {
            
            let identifier = "pin"
            var pinView:MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if pinView == nil {
                //println("Pinview was nil")
                
                //Create a plain MKAnnotationView if using a custom image...
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
            }
            else {
                //Unrelated to the image problem but...
                //Update the annotation reference if re-using a view...
                pinView?.annotation = annotation
            }
            
            
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: "pins")
            
            return pinView
        }
        return nil
        
    }
    
    
    
    
}

