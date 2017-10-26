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
    @IBOutlet weak var signUpButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        setUI(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view != emailTextField && touch.view != passwordTextField {
                hideKeyboard()
        }
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        hideKeyboard()
        if  emailTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter valid email ID")
        } else if passwordTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter password")
        } else {
            setUI(false)
            activityIndicator.startAnimating()
            UdacityClient.sharedInstance.login(username: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if let error = error {
                    performUIUpdatesOnMain {
                        self.presentAlert(title: "Oops an error occurred", error: error)
                        self.setUI(true)
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                if let user = result {
                    self.appDelegate.key = user["key"]
                    self.appDelegate.lastName = user["lastName"]
                    self.appDelegate.firstName = user["firstName"]
                }
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.completeLogin()
                }
            }
        }
    }
    
    func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        loadWebView("https://www.udacity.com/account/auth#!/signup")
    }
    
}

private extension LoginViewController {
    
    func hideKeyboard() {
        if emailTextField.isFirstResponder  {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isFirstResponder  {
            passwordTextField.resignFirstResponder()
        }
    }
    
    func setUI(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        signUpButton.isEnabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}
