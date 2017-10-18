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
}
