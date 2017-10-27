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
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(populateMap), name: .updatedLocations, object: nil)
        
        performUIUpdatesOnMain {
            (self.tabBarController as? TabBarViewController)?.getStudentLocations()
        }
    }

    @objc func populateMap() {

        for dictionary in Locations.sharedInstance.locationsArray {
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(dictionary.firstName) \(dictionary.lastName)"
            annotation.subtitle = dictionary.mediaURL
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
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle {
                guard let url = URL(string: urlString!) else {return}
                if(UIApplication.shared.canOpenURL(url)) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    presentAlert(title: "Broken link", error: "Looks like the user has not specified a proper social link")
                }
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
