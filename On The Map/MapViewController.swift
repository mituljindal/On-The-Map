//
//  MapViewController.swift
//  On The Map
//
//  Created by mitul jindal on 10/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var annotations = [MKPointAnnotation]()
//    var locationsArray: [[String: AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(populate(notification:)), name: .updatedLocations, object: nil)
        
        updateMap {
            (self.tabBarController as? TabBarViewController)?.getStudentLocations(skip: 0)
        }
    }
    
    func populate(notification: NSNotification) {
        print("got notification")
        populateMap()
    }

    func populateMap() {
        
//        self.locationsArray = appDelegate.locationsArray
        for dictionary in appDelegate.locationsArray {
            
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            var first: String! = ""
            var last: String! = ""
            var mediaURL: String! = ""
            
            if let _ = dictionary["firstName"] {
                first = dictionary["firstName"] as? String
            }
            if let _ = dictionary["lastName"] {
                last = dictionary["lastName"] as? String
            }
            if let _ = dictionary["mediaURL"] {
                mediaURL = dictionary["mediaURL"] as! String
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first!) \(last!)"
            annotation.subtitle = mediaURL!
            
            annotations.append(annotation)
        }
//        print(self)
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle {
                loadWebView(urlString!)
            }
        }
    }
}
