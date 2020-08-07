//
//  ViewModel.swift
//  MJNotes
//
//  Created by Mike Jones on 8/5/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

protocol ViewModelBindingDelegate: class {
    func updateViews()
}

public class ViewModel {
    
    var webSession: WebSession!
    var databaseService: DatabaseService!

    init(dbService: DatabaseService, webSession: WebSession) {
        self.webSession = webSession
        self.databaseService = dbService
    }
}
