//
//  AppCoordinator.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let databaseService: DatabaseService
    let webSession: WebSession
    
    let rootViewController: UINavigationController
    let listNotesCoordinator: ListNotesCoordinator

    init(window: UIWindow) {
        self.window = window
        databaseService = DatabaseService()
        webSession = WebSession()
        rootViewController = UINavigationController()

        listNotesCoordinator = ListNotesCoordinator(presenter: rootViewController, databaseService: databaseService, webSession: webSession)
    }

    func start() {
        window.rootViewController = rootViewController
        listNotesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
