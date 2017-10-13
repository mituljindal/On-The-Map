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
        
        var urlString = URLs.studentLocations
        if skip != 0 {
            urlString.append("?skip=\(skip)")
        }
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        let _ = handleHttpRequest(request: request, skipData: 0) { result, error in
            
            if error != nil {
                return
            }
            
            if let arr = result!["results"] {
                self.locationsArray = arr as! [[String : AnyObject]]
            }
            self.populateArray()
        }
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
        let request = NSMutableURLRequest(url: URL(string: URLs.logout)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 5) { (result, error) in
            
            if error != nil {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
