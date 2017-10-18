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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        let email = emailTextField.text!.isEmpty
//        if email.isValidEmail() {
        if  emailTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter valid email ID")
        } else if passwordTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter password")
        } else {
            setUI(false)
            var request = URLRequest(url: URL(string: URLs.login)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: RequestKeys.accept)
            request.addValue("application/json", forHTTPHeaderField: RequestKeys.contentType)
            request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
            let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request, skipData: 5) { (result, error) in
                if let _ = error {
                    self.presentAlert(title: "Oops an error occurred", error: "Please try again")
                    self.setUI(true)
                    return
                }
                
                if let account = result!["account"] as? [String: AnyObject] {
                    if let registered = account["registered"] as? Bool {
                        if registered == true {
                            if let id = account["key"] as? String {
                                self.getUserInfo(id)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserInfo(_ id: String) {
        
        var request = URLRequest(url: URL(string: URLs.getAccountInfo + id)!)
        request.httpMethod = "GET"
        let _ = UdacityClient.sharedInstance().handleHttpRequest(request: request, skipData: 5) { (result, error) in
            if let _ = error {
                self.presentAlert(title: "Oops an error occurred", error: "Please try again")
                self.setUI(true)
                return
            }
            
            if let user = result!["user"] as? [String: AnyObject] {
                if let lastName = user["last_name"] as? String {
                    print(lastName)
                    self.appDelegate.lastName = lastName
                }
                if let firstName = user["first_name"] as? String {
                    self.appDelegate.firstName = firstName
                }
            }
            self.completeLogin()
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
