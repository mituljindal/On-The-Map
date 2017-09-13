//
//  MapViewController.swift
//  On The Map
//
//  Created by mitul jindal on 10/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var appDelegate: AppDelegate!
    var annotations = [MKPointAnnotation]()
    var locationsArray: [[String: AnyObject]]!
    struct E: Error{}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.getStudentLocations()
        
    }
    
    func getStudentLocations() {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.presentAlert(title: "error", error: error)
                }
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!: ")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let arr = parsedResult["results"] {
                self.appDelegate.locationsArray = arr as! [[String : AnyObject]]
            }
//            print(self.appDelegate.locationsArray)
            self.populateMap()
        }
        task.resume()
    }
    
    func populateMap() {
        
        for dictionary in self.appDelegate.locationsArray! {
            
            var coordinate: CLLocationCoordinate2D?
            var first: String! = ""
            var last: String! = ""
            var mediaURL: String! = ""
            
//            guard let led = dictionary["latitude"] as? String else { throws (continue)  }
            
            if let latitude = dictionary["latitude"] {
                if latitude is NSNull {
                    continue
                } else {
                    let lat = CLLocationDegrees(latitude as! Double)
                    if let longitude = dictionary["longitude"] {
                        if longitude is NSNull {
                            continue
                        } else  {
                            let long = CLLocationDegrees(longitude as! Double)
                            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        }
                    } else  { continue }
                }
            } else { continue }
            
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
            annotation.coordinate = coordinate!
            annotation.title = "\(first!) \(last!)"
            annotation.subtitle = mediaURL!
            
            annotations.append(annotation)
        }
        print(annotations.count)
        
        self.mapView.addAnnotations(annotations)
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.canOpenURL(URL(string: toOpen)!)
            }
        }
    }
}

extension MapViewController {
    func presentAlert(title: String, error: String) {
        let ac = UIAlertController(title: title, message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
}
