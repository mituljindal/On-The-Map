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
    
    func getStudentLocations() {
        UdacityClient.sharedInstance().getStudentLocations() { result, error in
            
            if error != nil {
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Oops an error occured", error: "Please press refresh")
                }
                return
            }
            
            if let arr = result {
                self.appDelegate.locationsArray = arr
                NotificationCenter.default.post(name: .updatedLocations, object: nil)
            }
        }
    }
    
    func refresh() {
        self.getStudentLocations()
    }
    
    func logout() {
        
        UdacityClient.sharedInstance().logout() { (result, error) in
            
            if error != nil {
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Oops an error occured", error: "Please try again")
                }
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
