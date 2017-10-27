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
    
    func getStudentLocations() {
        
        UdacityClient.sharedInstance.getStudentLocations() { result, error in
            
            if error != nil {
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Oops an error occured", error: "Please press refresh")
                }
                return
            }
        }
    }
    
    func refresh() {
        self.getStudentLocations()
    }
    
    func logout() {
        
        UdacityClient.sharedInstance.logout() { (result, error) in
            
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
