//
//  ShowLocations.swift
//  On The Map
//
//  Created by mitul jindal on 22/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getObjectID(_ location: String, _ link: String, _ latitude: Double, _ longitude: Double, completion: @escaping (_ result: String?, _ error: String?) -> (Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: URLs.objectID)!)
        request.httpMethod = "POST"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        request.addValue(RequestValues.contentType, forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"uniqueKey\": \"\(self.key ?? "748492837")\", \"firstName\": \"\(self.firstName ?? "John")\", \"lastName\": \"\(self.lastName ?? "Doe")\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { result, error in
            if error != nil {
                performUIUpdatesOnMain {
                    completion(nil, "error")
                }
                return
            }
            
            guard let objectID = result!["objectId"] else {
                performUIUpdatesOnMain {
                    completion(nil, "error")
                }
                return
            }
            performUIUpdatesOnMain {
                self.postLocation(location, link, latitude, longitude, objectID as! String, completion: completion)
            }
        }
    }
    
    func postLocation(_ location: String, _ link: String, _ latitude: Double, _ longitude: Double, _ objectID: String, completion: @escaping (_ result: String?, _ error: String?) -> (Void)) {
        let urlString = URLs.postLocation + "\(objectID)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(RequestValues.XParseAppID, forHTTPHeaderField: RequestKeys.XParseAppID)
        request.addValue(RequestValues.XParseRestApi, forHTTPHeaderField: RequestKeys.XParseRestApi)
        request.addValue(RequestValues.contentType, forHTTPHeaderField: RequestKeys.contentType)
        request.httpBody = "{\"uniqueKey\": \"\(self.key ?? "748492837")\", \"firstName\": \"\(self.firstName ?? "John")\", \"lastName\": \"\(self.lastName ?? "Doe")\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let _ = handleHttpRequest(request: request as URLRequest, skipData: 0) { _, error in
            if error != nil {
                performUIUpdatesOnMain {
                    completion(nil, "error")
                }
                return
            }
            
            performUIUpdatesOnMain {
                completion("complete", nil)
            }
        }
    }
}
