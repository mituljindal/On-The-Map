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
    var locationsArray: [[String: AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationsArray = appDelegate.locationsArray
        NotificationCenter.default.addObserver(self, selector: #selector(populate(notification:)), name: .updatedLocations, object: nil)
        
        updateMap {
            (self.tabBarController as? TabBarViewController)?.getStudentLocations(skip: 0)
        }
    }
    
    @objc func populate(notification: NSNotification) {
        self.locationsArray = appDelegate.locationsArray
        populateMap()
    }

    func populateMap() {

        for dictionary in self.locationsArray {
            
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
                mediaURL = dictionary["mediaURL"] as? String
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first!) \(last!)"
            if mediaURL != nil {
                annotation.subtitle = mediaURL!
            }
            annotations.append(annotation)
        }
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
        print("1")
        if control == view.rightCalloutAccessoryView {
            print("2")
            if let urlString = view.annotation?.subtitle {
                print("3")
                guard let url = URL(string: urlString!) else {return}
                print("4")
                print(url)
                UIApplication.shared.open(url, options: [:])
                print("5")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.logout()
    }
    
    @IBAction func refresh(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.refresh()
    }
}
