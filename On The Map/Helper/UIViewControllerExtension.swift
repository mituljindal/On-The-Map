//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, error: String) {
        let ac = UIAlertController(title: title, message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func loadWebView(_ urlString: String) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = urlString
        present(controller, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let updatedLocations = Notification.Name("updatedLocations")
}
