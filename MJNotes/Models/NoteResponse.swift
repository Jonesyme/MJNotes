//
//  NoteResponse.swift
//  MJNotes
//
//  Created by Mike Jones on 8/4/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation

//
// MARK: - Note parsable from JSON
//
struct NoteResponse: Codable {
    var id: Int64
    var title: String
    var image: ImageWrap?
}
struct ImageWrap: Codable {
    var id: String
    var contentType: String
    var sizeURLs: ImageURLs
    enum CodingKeys: String, CodingKey {
        case id
        case contentType = "content_type"
        case sizeURLs = "size_urls"
    }
}
struct ImageURLs: Codable {
    var small: String
    var medium: String
    var large: String
}
