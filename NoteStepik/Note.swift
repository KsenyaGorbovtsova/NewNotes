//
//  Note.swift
//  NoteStepik
//
//  Created by Gorbovtsova Ksenya on 17/06/2019.
//  Copyright © 2019 Gorbovtsova Ksenya. All rights reserved.
//

import Foundation
import UIKit

struct Note: Hashable {
    
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let priority: Priority
    let dateOfSelfDestruction: Date?
    
    init (uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, priority: Priority, dateOfSelfDestruction: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.priority = priority
        self.dateOfSelfDestruction = dateOfSelfDestruction
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }
    }
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uid == rhs.uid
    }
}
enum Priority: String {
    case regular
    case important
    case irrelevant
}

