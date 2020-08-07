//
//  ListNotesViewModel.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation

class ListNotesViewModel: ViewModel {
    
    public var list: [Note] = Array()
    weak var delegate: ViewModelBindingDelegate?
    
    override init(dbService: DatabaseService, webSession: WebSession) {
        super.init(dbService: dbService, webSession: webSession)
    }
    
    public var rowCount: Int {
        return list.count
    }
    
    public func note(atIndexPath: IndexPath) -> Note {
        return list[atIndexPath.row]
    }
    
    public func loadLocalNotes() {
        let notes = databaseService.fetchAll(ofType: Note.self)
        list.append(contentsOf: notes)
    }
    
    public func loadServerNotes() {
        webSession.request(SaturnEndpoint.fetchNotes, responseType: [NoteResponse].self) { [weak self] result in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let response):
                var newList = [Note]()
                for noteParsable in response {
                    let note = Note(noteResponse: noteParsable)
                    try! self?.databaseService.realm.write {
                        self?.databaseService.realm.add(note, update: .modified)
                    }
                    newList.append(note)
                }
                self?.list.append(contentsOf: newList)
                self?.delegate?.updateViews()
            }
        }
    }
    
    public func syncNote(atIndexPath: IndexPath, completion: @escaping (Bool) -> ()) {
        let note = self.note(atIndexPath: atIndexPath)
        guard let image = note.localImage() else {
            completion(false);
            return
        }

        webSession.request(SaturnEndpoint.uploadImage(image), responseType: ImageResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.webSession.request(SaturnEndpoint.uploadNote(title: note.caption, imageID: response.id), responseType: NoteResponse.self) { innerResult in
                    switch result {
                    case .success(_):
                        completion(true)
                    case .error(let error):
                        print("Error uploading image: " + error.localizedDescription)
                        completion(false)
                    }
                }
            case .error(let error):
                print("Error uploading image: " + error.localizedDescription)
                completion(false)
            }
        }
    }
}
