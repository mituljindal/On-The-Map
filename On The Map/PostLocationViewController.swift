//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var socialLinkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.delegate = textFieldDelegate
        socialLinkTextField.delegate = textFieldDelegate
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findPressed(_ sender: Any) {
        
        guard  let searchQuery = locationTextField.text else {
            presentAlert(title: "No Location", error: "Please enter location to search")
            return
        }
        
        guard let socialLink = socialLinkTextField.text else {
            presentAlert(title: "No Social Link", error: "Please enter your social link")
            return
        }
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "showLocationViewController") as! ShowLocationViewController
        
        controller.searchQuery = searchQuery
        controller.socialLink = socialLink
        self.navigationController?.pushViewController(controller, animated: true)
    }
        
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchQuery
//
//        let search = MKLocalSearch(request: request)
//        search.start(completionHandler: { response, error in
//            guard (error == nil) else {
//                updateMap {
//                    self.presentAlert(title: "Try again!", error: "An error occurred. Try a different location")
//                }
//                return
//            }
//            guard let response = response else { return }
//            self.updateUI()
//            self.dropPinZoomIn(placemark: response.mapItems[0].placemark)
//        })
    
//    @IBAction func submitPressed(_ sender: Any) {
//
//        self.getObjectID()
//        dismiss(animated: true, completion: nil)
//    }
}

extension PostLocationViewController {
//    func dropPinZoomIn(placemark:MKPlacemark){
//        // cache the pin
//        selectedPin = placemark
//        // clear existing pins
//        myMapView.removeAnnotations(myMapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            locationString = "\(city), \(state)"
//            annotation.subtitle = locationString
//        }
//        myMapView.addAnnotation(annotation)
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
//        myMapView.setRegion(region, animated: true)
//    }
    
//    func getObjectID() {
    
//        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//        request.httpMethod = "POST"
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"Mitul\", \"lastName\": \"Jindal\",\"mapString\": \"\(locationString.lowercased())\", \"mediaURL\": \"\(topTextField.text ?? "www.google.com")\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
//        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { result, error in
//            if error != nil {
//                return
//            }
//
//            guard let objectID = result!["objectId"] else {
//                performUIUpdatesOnMain {
//                    self.presentAlert(title: "Error Occuted", error: "No data was returned by the request!")
//                }
//                return
//            }
//            self.postLocation(objectID as! String)
//        }
//    }
    
//    func postLocation(_ objectID: String) {
//        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)"
//        let url = URL(string: urlString)
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "PUT"
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"uniqueKey\": \"748492837\", \"firstName\": \"Mitul\", \"lastName\": \"Jindal\",\"mapString\": \"\(locationString.lowercased())\", \"mediaURL\": \"\(topTextField.text ?? "www.google.com")\",\"latitude\": \(selectedPin?.coordinate.latitude ?? 0), \"longitude\": \(selectedPin?.coordinate.longitude ?? 0)}".data(using: String.Encoding.utf8)
//        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { _, _ in
//            
//        }
//    }
}

//extension UITextViewDelegate {
//    
//}
