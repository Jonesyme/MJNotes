//
//  SaturnEndpoint.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - Saturn-specific Web Service Endpoints
//

public enum SaturnEndpoint {
    case uploadImage(_ image: UIImage)              // post image to server
    case uploadNote(title: String, imageID: String) // post note to server
    case fetchNotes                                 // get all note objects from server
}

extension SaturnEndpoint: WSEndpointProtocol {
    
    public var scheme: WebSession.RequestScheme {
        return .HTTPS
    }
    
    public var requestMethod: WebSession.RequestMethod {
        switch self {
        case .uploadImage(_):
            return .POST
        case .uploadNote(_, _):
            return .POST
        case .fetchNotes:
            return .GET
        }
    }
    
    public var requestType: WebSession.RequestType {
        switch self {
        case .uploadImage(_):
            return .MULTIPART
        case .uploadNote(_, _):
            return .BASIC
        case .fetchNotes:
            return .BASIC
        }
    }
    
    public var host: String {
        return "env-develop.saturn.engineering"
    }

    public var path: String {
        switch self {
        case .uploadImage(_):
            return "/api/v2/test-notes/photo"
        case .uploadNote(_, _):
            return "/api/v2/test-notes"
        case .fetchNotes:
            return "/api/v2/test-notes"
        }
    }
    
    public var params: [URLQueryItem] {
        switch self {
        case .uploadImage(_):
            return []
        case .uploadNote(_,_): // let title, let imageID):
            return []
        case .fetchNotes:
            return []
        }
    }
    
    public var fileData: Data? {
        switch self {
        case .uploadImage(let image):
            return image.jpegData(compressionQuality: 1)
        default:
            return nil
        }
    }
    
    public var formData: [String : String]? {
        switch self {
        case .uploadNote(let title, let imageID):
            return ["title": title, "image_id": imageID]
        default:
            return nil
        }
    }
}

