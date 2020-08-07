//
//  CreateNoteViewModel.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit


class CreateNoteViewModel: ViewModel {
    
    var thumbImage: Observable<UIImage> = Observable()
    
    override init(dbService: DatabaseService, webSession: WebSession) {
        super.init(dbService: dbService, webSession: webSession)
    }
    
    func storeNoteLocally(caption: String, image: UIImage) {
        let _ = Note(caption: caption, image: image, dbService: self.databaseService)
    }
}
