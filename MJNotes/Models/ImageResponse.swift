//
//  ImageResponse.swift
//  MJNotes
//
//  Created by Mike Jones on 8/4/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//


//
// MARK: - Image upload response
//
struct ImageResponse: Codable {
    var id: String
    var imageType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageType = "content_type"
    }
}
