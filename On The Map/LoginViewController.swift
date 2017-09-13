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
    
    var userID: String!
    var sessionID: String!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
        
        if emailTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter your email ID")
        } else if passwordTextField.text!.isEmpty {
            presentAlert(title: "Try again!", error: "Please enter password")
        } else {
            setUI(false)
            
            var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
                
                func displayError(_ error: String) {
                    print(error)
                    performUIUpdatesOnMain {
                        self.setUI(true)
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
                
                let range = Range(5..<data.count)
                
                let newData = data.subdata(in: range)
                
                let parsedResult: [String:AnyObject]!
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    displayError("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                if let account = parsedResult["account"] as? [String: AnyObject] {
                    if let registered = account["registered"] as? Bool {
                        if registered == true {
                            self.userID = account["key"] as! String
                            self.sessionID = (parsedResult["session"] as! [String: AnyObject])["id"] as! String
                            self.getStudentLocations()
                        } else {
                            self.presentAlert(title: "Account not found", error: "Incorrect username or password")
                            return
                        }
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func getStudentLocations() {
        
        self.completeLogin()
    }
    
    func completeLogin() {
        
        appDelegate.loginDetails = .init(userID: self.userID!, sessionID: self.sessionID!)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapTabController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
}

private extension LoginViewController {
    
    func presentAlert(title: String, error: String) {
        let ac = UIAlertController(title: title, message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
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