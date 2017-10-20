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
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var myMapView: MKMapView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        self.search()
    }
    
    func search() {
        activityIndicator.startAnimating()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchQuery
    
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, error in
            guard (error == nil) else {
                updateMap {
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Try again!", error: "An error occurred. Try a different location")
                }
                return
            }
            guard let response = response else { return }
            self.dropPinZoomIn(placemark: response.mapItems[0].placemark)
            self.activityIndicator.stopAnimating()
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
        
        let request = NSMutableURLRequest(url: URL(string: URLs.objectID)!)
        request.httpMethod = "POST"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        request.addValue(RequestValues.contentType, forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"\(self.appDelegate.firstName ?? "John")\", \"lastName\": \"\(self.appDelegate.lastName ?? "Doe")\",\"mapString\": \"\(locationString!.lowercased() )\", \"mediaURL\": \"\(socialLink!)\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
        let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request as URLRequest, skipData: 0) { result, error in
            if error != nil {
                self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                return
            }
            
            guard let objectID = result!["objectId"] else {
                self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                return
            }
            
            self.postLocation(objectID as! String)
        }
    }
    
    func postLocation(_ objectID: String) {
        let urlString = URLs.postLocation + "\(objectID)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        request.addValue(RequestValues.contentType, forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"\(self.appDelegate.firstName ?? "John")\", \"lastName\": \"\(self.appDelegate.lastName ?? "Doe")\",\"mapString\": \"\(locationString!.lowercased() )\", \"mediaURL\": \"\(socialLink!)\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
        
        let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request as URLRequest, skipData: 0) { _, error in
            if error != nil {
                self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                return
            }
        }
    }
}
