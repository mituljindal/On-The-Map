//
//  UdacityClient.swift
//  On The Map
//
//  Created by mitul jindal on 19/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

class UdacityClient {
    
    func login(username: String, password: String, completion: @escaping (_ result: [String: String]?, _ error: String?) -> (Void)) {
        var request = URLRequest(url: URL(string: URLs.login)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: RequestKeys.accept)
        request.addValue("application/json", forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let _ = handleHttpRequest(request: request, skipData: 5) { result, error in
            
            func handleError() {
                performUIUpdatesOnMain {
                    completion(nil, "An error occured")
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
            studentDetails["firstName"] = firstName
            studentDetails["lastName"] = lastName
            performUIUpdatesOnMain {
                completion(studentDetails, nil)
            }
        }
    }
    
    func handleHttpRequest(request: URLRequest, skipData: Int, completion: @escaping (_ result: [String: AnyObject]?, _ error: String?) -> (Void)) -> URLSessionDataTask{
        
        func handlerError(error: String) {
            performUIUpdatesOnMain {
                completion(nil, error)
//                return
            }
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            guard (error == nil) else {
                handlerError(error: (error as! String))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            if (statusCode < 200 && statusCode > 299) {
                handlerError(error: "Your request returned a status code other than 2xx!: \(statusCode)")
                return
            }
            
            guard let data = data else {
                handlerError(error: "No data was returned by the request!")
                return
            }
            
            let range = Range(skipData..<data.count)
            
            let newData = data.subdata(in: range)
            
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                performUIUpdatesOnMain {
                    completion(nil, "Could not parse the data as JSON: '\(data)'")
                }
                return
            }
            performUIUpdatesOnMain {
                completion(parsedResult, nil)
            }
        }
        task.resume()
        
        return task
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
