//
//  Note.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import Foundation
import SwiftData

@Model
class Note {
    var content: String
    var createdAt: Date
    
    init(content: String, createdAt: Date) {
        self.content = content
        self.createdAt = createdAt
    }
}
