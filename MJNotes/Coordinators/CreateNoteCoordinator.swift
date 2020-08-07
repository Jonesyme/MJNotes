//
//  AddNoteCoordinator.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit

class CreateNoteCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private weak var listNotesViewController: ListNotesViewController?
    private var createNoteViewController: CreateNoteViewController?
    private let databaseService: DatabaseService
    private let webSession: WebSession
    
    public var refreshNoteList = false
    
    init(presenter: UINavigationController, dbService: DatabaseService, webSession: WebSession) {
        self.presenter = presenter
        self.databaseService = dbService
        self.webSession = webSession
    }

    func start() {
        let createNoteViewModel = CreateNoteViewModel(dbService: databaseService, webSession: webSession)
        let createNoteVC = CreateNoteViewController(viewModel: createNoteViewModel)
        let navWrapper = UINavigationController(rootViewController: createNoteVC)
        presenter.modalPresentationStyle = .overCurrentContext
        presenter.present(navWrapper, animated: true, completion: {
            if self.refreshNoteList {
                // TODO
                // listNotesViewController.refetchData()
            }
        })

        self.createNoteViewController = createNoteVC
    }
    
    func presentImagePicker() {
        
    }
}
