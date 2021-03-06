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
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Try again!", error: "An error occurred. Try a different location")
                }
                return
            }
            guard let response = response else { return }
            self.dropPinZoomIn(placemark: response.mapItems[0].placemark)
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        self.activityIndicator.startAnimating()
        let location = self.locationString!.lowercased()
        let link = self.socialLink!
        let latitude = self.selectedPin?.coordinate.latitude ?? 0
        let longitude = self.selectedPin?.coordinate.longitude ?? 0
        
        UdacityClient.sharedInstance.getObjectID(location, link, latitude, longitude) { result, error in
            if error != nil {
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Oops", error: "An error occured, please try again!")
                }
                return
            }
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true) {
                    print("called")
                    UdacityClient.sharedInstance.getStudentLocations(completion: ) { (_,_) in
                        
                    }
                }
            }
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
}
