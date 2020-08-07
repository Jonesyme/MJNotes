//
//  NoteCellViewModel.swift
//  MJNotes
//
//  Created by Mike Jones on 8/2/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//


class NoteCellViewModel {

    var caption: Observable<String> = Observable()
    var imageURL: Observable<String> = Observable()
    var synced: Observable<Bool> = Observable()

    init(_ note: Note) {
        self.caption.value = note.caption
        self.imageURL.value = note.imageURL
        self.synced.value = note.synced
    }
}
