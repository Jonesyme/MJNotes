//
//  DatabaseService.swift
//  MJNotes
//
//  Created by Mike Jones on 8/2/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseServiceProtocol {
    func fetchAll<T:Object>(ofType: T.Type) -> [T]
    func insert<T:Object>(_ object: T)
}

class DatabaseService: DatabaseServiceProtocol {
    
    var realm: Realm!
    lazy var defaultConfig = Realm.Configuration()
    
    init(realmConfig: Realm.Configuration? = nil) {
        do {
            if let config = realmConfig {
                self.realm = try Realm(configuration: config)
            } else {
                self.realm = try Realm(configuration: self.defaultConfig)
            }
        } catch let error as NSError {
            NSLog("Error creating realm database: " + error.description)
        }
    }
    
    func fetchAll<T:Object>(ofType: T.Type) -> [T] {
        let results = realm.objects(T.self)
        return results.compactMap{$0}
    }
    
    func insert<T:Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            NSLog("Error writing to realm database: " + error.description)
        }
    }
}
