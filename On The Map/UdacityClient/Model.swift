//
//  Initializers.swift
//  On The Map
//
//  Created by mitul jindal on 20/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

struct StudentInformation {
    var firstName =  String()
    var lastName = String()
    var latitude = Double()
    var longitude = Double()
    var mapString = String()
    var mediaURL = String()
    
    init(_ location: [String: Any]) {
        self.firstName = location["firstName"] as? String ?? "John"
        self.lastName = location["lastName"] as? String ?? "Doe"
        self.latitude = location["latitude"] as? Double ?? 0.0
        self.longitude = location["longitude"] as? Double ?? 0.0
        self.mapString = location["mapString"] as? String ?? ""
        self.mediaURL = location["mediaURL"] as? String ?? "https://www.udacity.com"
    }
}

class Locations {
    
    var locationsArray: [StudentInformation] = []
    var lastName: String?
    var firstName: String?
    var key: String?
    
    static let sharedInstance = Locations()
}
