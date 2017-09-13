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
    var appDelegate: AppDelegate!
    var annotations = [MKPointAnnotation]()
    var locationsArray: [[String: AnyObject]]!
    struct E: Error{}
    var tab: TabBarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("In viewDidLoad of MapViewController")
        
//        (self.tabBarController as? CustomTabBarController)?.myFunctionToCallFromAnywhere()
        (self.tabBarController as? TabBarViewController)?.getStudentLocations(skip: 0)
//        print("after")
        
//        tab = tabBarController as? TabBarViewController
//        tab.getStudentLocations(skip: 0)
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationsArray = appDelegate.locationsArray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("calling populate map")
        locationsArray = appDelegate.locationsArray
        populateMap()
        
//        if self.appDelegate.locationsArray.count == 0 {
//            self.getStudentLocations()
//        } else {
//            print(self.appDelegate.locationsArray)
//            print("appDelegate array not empty")
//            self.populateMap(self.appDelegate.locationsArray)
//        }
    }
    
//    func getStudentLocations() {
//        
//        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//        request.httpMethod = "GET"
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            func displayError(_ error: String) {
//                print(error)
//                performUIUpdatesOnMain {
//                    self.presentAlert(title: "error", error: error)
//                }
//            }
//            
//            guard (error == nil) else {
//                displayError("There was an error with your request: \(error!)")
//                return
//            }
//            
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                displayError("Your request returned a status code other than 2xx!: ")
//                return
//            }
//            
//            guard let data = data else {
//                displayError("No data was returned by the request!")
//                return
//            }
//            
//            let parsedResult: [String:AnyObject]!
//            do {
//                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
//            } catch {
//                displayError("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            if let arr = parsedResult["results"] {
//                self.locationsArray = arr as! [[String : AnyObject]]
//            }
//            self.populateMap(self.locationsArray!)
//        }
//        task.resume()
//    }
    
    func populateMap() {
        
        for dictionary in self.locationsArray {
            
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            var first: String! = ""
            var last: String! = ""
            var mediaURL: String! = ""
            
//            guard let led = dictionary["latitude"] as? String else { throws (continue)  }
            
//            if let latitude = dictionary["latitude"] {
//                if latitude is NSNull {
//                    continue
//                } else {
//                    let lat = CLLocationDegrees(latitude as! Double)
//                    if let longitude = dictionary["longitude"] {
//                        if longitude is NSNull {
//                            continue
//                        } else  {
//                            let long = CLLocationDegrees(longitude as! Double)
//                            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                        }
//                    } else  { continue }
//                }
//            } else { continue }
            
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
//            self.appDelegate.locationsArray.append(dictionary)
        }
//        print(annotations)
//        print(annotations.count)
        
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
            if let urlString = view.annotation?.subtitle {
                loadWebView(urlString!)
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
    
    func loadWebView(_ urlString: String) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = urlString
        present(controller, animated: true, completion: nil)
    }
}
