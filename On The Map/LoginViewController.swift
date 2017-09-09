//
//  ViewController.swift
//  On The Map
//
//  Created by mitul jindal on 29/08/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var logoImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if emailTextField.isFirstResponder && touch.view != emailTextField {
                emailTextField.resignFirstResponder()
            } else if passwordTextField.isFirstResponder && touch.view != passwordTextField {
                passwordTextField.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with: event)
    }
   
    
}
