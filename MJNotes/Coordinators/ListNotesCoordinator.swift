//
//  NoteListCoordinator.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit

class ListNotesCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var createNoteCoordinator: CreateNoteCoordinator?
    private var listNotesViewController: ListNotesViewController?
    private let databaseService: DatabaseService
    private let webSession: WebSession
    
    init(presenter: UINavigationController, databaseService: DatabaseService, webSession: WebSession) {
        self.presenter = presenter
        self.databaseService = databaseService
        self.webSession = webSession
    }

    func start() {
        let listNotesViewModel = ListNotesViewModel(dbService: databaseService, webSession: webSession)
        let listNotesViewController = ListNotesViewController(viewModel: listNotesViewModel)
        listNotesViewController.delegate = self
        presenter.pushViewController(listNotesViewController, animated: true)

        self.listNotesViewController = listNotesViewController
    }
}

// MARK: - NoteListViewControllerDelegate
extension ListNotesCoordinator: ListNotesViewControllerDelegate
{
    func createNewNote() {
        let createNoteCoordinator = CreateNoteCoordinator(presenter: presenter, dbService: self.databaseService, webSession: self.webSession)
        createNoteCoordinator.start()

        self.createNoteCoordinator = createNoteCoordinator
    }
}
