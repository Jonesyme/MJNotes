//
//  Observable.swift
//  MJNotes
//
//  Created by Mike Jones on 8/2/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value!)
            }
        }
    }
    var valueChanged: ((T) -> Void)?
    
}
