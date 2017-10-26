//
//  GetLocations.swift
//  On The Map
//
//  Created by mitul jindal on 22/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getStudentLocations(completion: @escaping (_ result: Bool, _ error: String?) -> (Void)) {
        
        let urlString = URLs.studentLocations
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        let _ = handleHttpRequest(request: request, skipData: 0) { result, error in
            
            if error != nil {
                performUIUpdatesOnMain {
                    completion(false, error)
                }
                return
            }
            
            var locationsArray = [StudentInformation]()
            
            if let arr = result!["results"] as? [[String: AnyObject]] {
                for location in arr {
                    locationsArray.append(StudentInformation(location))
                }
                self.locationsArray = locationsArray
                performUIUpdatesOnMain {
                    completion(true, nil)
                }
            }
        }
    }
    
    func logout(completion: @escaping (_ result: String?, _ error: String?) -> (Void)) {
        let request = NSMutableURLRequest(url: URL(string: URLs.logout)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 5) { (result, error) in
            
            if error != nil {
                performUIUpdatesOnMain {
                    completion(nil, "Error Occured")
                }
                return
            }
            
            performUIUpdatesOnMain {
                completion("complete", nil)
            }
        }
    }
}
