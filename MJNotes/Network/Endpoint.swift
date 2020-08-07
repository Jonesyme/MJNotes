//
//  Endpoint.swift
//  MJNotes
//
//  Created by Mike Jones on 8/5/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation

public protocol WSEndpointProtocol {
    var scheme: WebSession.RequestScheme { get }
    var requestMethod: WebSession.RequestMethod { get }
    var requestType: WebSession.RequestType { get }
    var host: String { get }
    var path: String { get }
    var params: [URLQueryItem] { get }
    var fileData: Data? { get }
    var formData: [String:String]? { get }
}
