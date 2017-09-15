//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var selectedPin:MKPlacemark? = nil
    var textViewDelegate = TextViewDelegate()
    var textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomTextView.delegate = textViewDelegate
        bottomTextView.text = "Enter the location"
        topTextField.attributedPlaceholder = NSAttributedString(string: "Enter your social link",
                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])
        topTextField.delegate = textFieldDelegate
        topView.backgroundColor = #colorLiteral(red: 0.9214684367, green: 0.921626389, blue: 0.9214583635, alpha: 1)
        bottomView.backgroundColor = #colorLiteral(red: 0.9214684367, green: 0.921626389, blue: 0.9214583635, alpha: 1)
        topTextView.backgroundColor = #colorLiteral(red: 0.9214684367, green: 0.921626389, blue: 0.9214583635, alpha: 1)
        topTextView.isHidden = false
        bottomTextView.backgroundColor = #colorLiteral(red: 0.1677085161, green: 0.4406689107, blue: 0.7313830256, alpha: 1)
        bottomTextView.isHidden = false
        bottomTextView.textColor = UIColor.white
        topTextField.isHidden = true
        topTextField.textColor = UIColor.white
//        topTextField.pl
//        topTextField.placeholder = "Enter your social link"
        findButton.isHidden = false
        myMapView.isHidden = true
        submitButton.isHidden = true
        topTextView.isEditable = false
//        cancelButton.titleColor(for: .normal) = #colorLiteral(red: 0.1677085161, green: 0.4406689107, blue: 0.7313830256, alpha: 1)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findPressed(_ sender: Any) {
        
        guard  let searchQuery = bottomTextView.text else {
            presentAlert(title: "No Location", error: "Please enter location to search")
            return
        }
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
            self.updateUI()
            self.dropPinZoomIn(placemark: response.mapItems[0].placemark)
        })
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Mitul\", \"lastName\": \"Jindal\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}

extension PostLocationViewController {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        myMapView.removeAnnotations(myMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        myMapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        myMapView.setRegion(region, animated: true)
    }
    
    func updateUI() {
        topView.backgroundColor = #colorLiteral(red: 0.1677085161, green: 0.4406689107, blue: 0.7313830256, alpha: 1)
        topTextView.isHidden = true
        bottomTextView.isHidden = true
        topTextField.isHidden = false
        findButton.isHidden = true
        myMapView.isHidden = false
        submitButton.isHidden = false
        cancelButton.setTitleColor(.white, for: .normal)
    }
}

//extension UITextViewDelegate {
//    
//}
