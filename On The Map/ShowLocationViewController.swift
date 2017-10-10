//
//  ShowLocationViewController.swift
//  On The Map
//
//  Created by mitul jindal on 07/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class ShowLocationViewController: UIViewController {
    
    var searchQuery: String!
    var socialLink: String!
    var selectedPin: MKPlacemark? = nil
    var locationString: String!
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.search()
    }
    
    func search() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchQuery
    
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, error in
            guard (error == nil) else {
                updateMap {
                    self.presentAlert(title: "Try again!", error: "An error occurred. Try a different location")
                }
                return
            }
            guard let response = response else { return }
            self.dropPinZoomIn(placemark: response.mapItems[0].placemark)
        })
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        self.getObjectID()
        self.dismiss(animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShowLocationViewController {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        myMapView.removeAnnotations(myMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality {
            if let state = placemark.administrativeArea {
                locationString = "\(city), \(state)"
            } else {
                locationString = "\(city)"
            }
        } else {
            locationString = searchQuery
        }
        annotation.subtitle = locationString
        myMapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        myMapView.setRegion(region, animated: true)
    }
    
    func getObjectID() {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"Mitul\", \"lastName\": \"Jindal\",\"mapString\": \"\(locationString!.lowercased() )\", \"mediaURL\": \"\(socialLink!)\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { result, error in
            if error != nil {
                self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                return
            }
            
            guard let objectID = result!["objectId"] else {
                return
            }
            
            self.postLocation(objectID as! String)
        }
    }
    
    func postLocation(_ objectID: String) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"Mitul\", \"lastName\": \"Jindal\",\"mapString\": \"\(locationString.lowercased())\", \"mediaURL\": \"\(socialLink ?? "www.google.com")\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
        
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { _, error in
            if error != nil {
                self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                return
            }
        }
    }
}
