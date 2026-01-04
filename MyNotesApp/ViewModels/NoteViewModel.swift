//
//  NoteViewModel.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import Foundation
import Observation

@Observable
@MainActor
class NoteViewModel {
    var content: String = ""
    
    func isNoteValid() -> Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func trimmedContent() -> String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func search(for searchTherm: String, from notes: [Note]) -> [Note] {
        if searchTherm.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.content.localizedStandardContains(searchTherm)
            }
        }
    }
}
