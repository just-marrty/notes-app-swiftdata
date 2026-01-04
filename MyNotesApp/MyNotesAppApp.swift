//
//  MyNotesAppApp.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import SwiftUI
import SwiftData

@main
struct MyNotesAppApp: App {
    var body: some Scene {
        WindowGroup {
            NoteMainView()
                .modelContainer(for: Note.self, inMemory: false)
        }
    }
}
