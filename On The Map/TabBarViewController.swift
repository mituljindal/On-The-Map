//
//  TabBarViewController.swift
//  On The Map
//
//  Created by mitul jindal on 13/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationsArray: [[String: AnyObject]]!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print("In TabBarViewController")
//        
//        appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        self.getStudentLocations(skip: 0)
//    }
    
    func getStudentLocations(skip: Int) {
        
        self.locationsArray = nil
//        print("getting locations")
        
        var urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        if skip != 0 {
            urlString.append("?skip=\(skip)")
        }
        var request = URLRequest(url: URL(string: urlString)!)
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
                self.locationsArray = arr as! [[String : AnyObject]]
            }
//            self.populateMap(self.locationsArray!)
//            print("got locations")
            self.populateArray()
        }
        task.resume()
    }
    
    func populateArray() {
        
//        print("populating array")
        var i = 100
        
        for dictionary in self.locationsArray {
            
//            var coordinate: CLLocationCoordinate2D?
        
            if let latitude = dictionary["latitude"] {
                if latitude is NSNull {
                    continue
                } else {
//                    let lat = CLLocationDegrees(latitude as! Double)
                    if let longitude = dictionary["longitude"] {
                        if longitude is NSNull {
                            continue
                        } else  {
//                            let long = CLLocationDegrees(longitude as! Double)
//                            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        }
                    } else  { continue }
                }
            } else { continue }
        
            if let _ = dictionary["mediaURL"] {
            } else {
                continue
            }
            
            self.appDelegate.locationsArray.append(dictionary)
            if self.appDelegate.locationsArray.count == 100 {
                break
            }
            
//            print("added one location")
        }
        if self.appDelegate.locationsArray.count < 100 {
            getStudentLocations(skip: i)
            i += 100
        }
//        print(appDelegate.locationsArray.count)
//        print("array populated")
    }
    
}

extension TabBarViewController {
    func presentAlert(title: String, error: String) {
        let ac = UIAlertController(title: title, message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
}