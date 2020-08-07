//
//  Price.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift


//
// MARK: - Note to interface with Realm
//
public class Note: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var synced: Bool = false
    @objc dynamic var image: UIImage? = nil
    
    // initialize note from server
    convenience init(noteResponse: NoteResponse) {
        self.init()
        id = String(noteResponse.id)
        caption = noteResponse.title
        synced = true
        if let url = noteResponse.image?.sizeURLs.small {
            imageURL = url
        }
    }
    
    // initalize local note
    convenience init(caption: String, image: UIImage, dbService: DatabaseService) {
        self.init()
        self.id = UUID().uuidString
        self.caption = caption
        self.imageURL = ""
        self.synced = false
        
        // store local image
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        let path = documentURL?.appendingPathComponent(self.id + ".png")
        if let filePath = path {
            do  {
                try image.pngData()?.write(to: filePath, options: .atomic)
            } catch let err {
                print("Saving file resulted in error: ", err)
            }
        }
        
        // save to database
        try! dbService.realm.write {
            dbService.realm.add(self, update: .modified)
        }
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }

    override public static func ignoredProperties() -> [String] {
        return ["image"]
    }
  
    public func localImage() -> UIImage? {
        if let filePath = Note.filePath(forKey: self.id),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    public static func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
}

