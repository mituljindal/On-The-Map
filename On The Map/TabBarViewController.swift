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
    let map = MapViewController()
    let list = ListViewController()
    
    func getStudentLocations(skip: Int) {
        
        self.locationsArray = nil
        
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
            self.populateArray()
        }
        task.resume()
    }
    
    func populateArray() {
        
        for dictionary in self.locationsArray {
        
            if let latitude = dictionary["latitude"] {
                if latitude is NSNull {
                    continue
                } else {
                    if let longitude = dictionary["longitude"] {
                        if longitude is NSNull {
                            continue
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
        }
        
        if self.appDelegate.locationsArray.count < 100 {
            getStudentLocations(skip: 100)
        } else {
            NotificationCenter.default.post(name: .updatedLocations, object: nil)
        }
    }
    
    func refresh() {
        self.appDelegate.locationsArray = []
        self.getStudentLocations(skip: 0)
    }
    
    func logout() {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            self.dismiss(animated: true, completion: nil)
        }
        task.resume()
    }
}
