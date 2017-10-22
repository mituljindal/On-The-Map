//
//  Constants.swift
//  On The Map
//
//  Created by mitul jindal on 04/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

struct URLs {
    static let studentLocations = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
    static let logout = "https://www.udacity.com/api/session"
    static let objectID = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let postLocation = "https://parse.udacity.com/parse/classes/StudentLocation/"
    static let login = "https://www.udacity.com/api/session"
    static let getAccountInfo = "https://www.udacity.com/api/users/"
}

struct RequestKeys {
    static let XParseAppID = "X-Parse-Application-Id"
    static let XParseRestApi = "X-Parse-REST-API-Key"
    static let contentType = "Content-Type"
    static let accept = "Accept"
}

struct RequestValues {
    static let XParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let XParseRestApi = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let contentType = "application/json"
}


