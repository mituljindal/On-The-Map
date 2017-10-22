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
    var locationsArray: [studentInformation]! = []
    let map = MapViewController()
    let list = ListViewController()
    
    func getStudentLocations() {
        
        let urlString = URLs.studentLocations
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request, skipData: 0) { result, error in
            
            if error != nil {
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Oops an error occured", error: "Please press refresh")
                }
                return
            }
            
            if let arr = result!["results"] as? [[String: AnyObject]] {
                for location in arr {
                    self.appDelegate.locationsArray.append(studentInformation(location))
                }
                NotificationCenter.default.post(name: .updatedLocations, object: nil)
            }
        }
    }
    
    func refresh() {
        self.appDelegate.locationsArray = []
        self.getStudentLocations()
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
        let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request as URLRequest, skipData: 5) { (result, error) in
            
            if error != nil {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
