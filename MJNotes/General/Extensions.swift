//
//  Extensions.swift
//  MJNotes
//
//  Created by Mike Jones on 8/3/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit

//
// MARK - UIColor extension
//
extension UIColor {
    public class var NotesGray:  UIColor { get { return UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)} }
    public class var ButtonGray: UIColor { get { return UIColor.init(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1.0)} }
}

//
// MARK - NSMutableData extension
//
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
