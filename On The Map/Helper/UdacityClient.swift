//
//  UdacityClient.swift
//  On The Map
//
//  Created by mitul jindal on 19/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

class UdacityClient {
    
    func handleHttpRequest(request: URLRequest, skipData: Int, completion: @escaping (_ result: [String: AnyObject]?, _ error: String?) -> (Void)) -> URLSessionDataTask{
        
        func handlerError(error: String) {
            performUIUpdatesOnMain {
                completion(nil, error)
                return
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
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            completion(parsedResult, nil)
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
