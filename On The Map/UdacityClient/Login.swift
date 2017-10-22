//
//  UdacityLogin.swift
//  On The Map
//
//  Created by mitul jindal on 22/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func login(username: String, password: String, completion: @escaping (_ result: [String: String]?, _ error: String?) -> (Void)) {
        var request = URLRequest(url: URL(string: URLs.login)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: RequestKeys.accept)
        request.addValue("application/json", forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let _ = handleHttpRequest(request: request, skipData: 5) { result, error in
            
            func handleError() {
                performUIUpdatesOnMain {
                    completion(nil, "Please check email ID and password")
                }
            }
            
            if error != nil {
                completion(nil, error)
            }
            
            if let account = result!["account"] as? [String: AnyObject] {
                if let registered = account["registered"] as? Bool {
                    if registered == true {
                        if let id = account["key"] as? String {
                            self.getUserInfo(id, completion: completion)
                        } else { handleError()
                            return
                        }
                    } else { handleError()
                        return
                    }
                } else { handleError()
                    return
                }
            } else { handleError()
                return
            }
        }
    }
    
    func getUserInfo(_ id: String, completion: @escaping (_ result: [String: String]?, _ error: String?) -> (Void)) {
        var request = URLRequest(url: URL(string: URLs.getAccountInfo + id)!)
        request.httpMethod = "GET"
        let _ = handleHttpRequest(request: request, skipData: 5) { result, error in
            if let _ = error {
                return
            }
            var lastName: String
            var firstName: String
            if let user = result!["user"] as? [String: AnyObject] {
                if let _ = user["last_name"] as? String {
                    lastName = user["last_name"] as! String
                } else { lastName = "Doe" }
                if let _ = user["first_name"] as? String {
                    firstName = user["first_name"] as! String
                } else { firstName = "John" }
            } else {
                performUIUpdatesOnMain {
                    completion(nil, "Can't find user account")
                }
                return
            }
            var studentDetails = [String: String]()
            studentDetails["key"] = id
            studentDetails["firstName"] = firstName
            studentDetails["lastName"] = lastName
            performUIUpdatesOnMain {
                completion(studentDetails, nil)
            }
        }
    }
}
