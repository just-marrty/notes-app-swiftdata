//
//  NoteMainView.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import SwiftUI
import SwiftData

struct NoteMainView: View {
    
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    
    var body: some View {
        NavigationStack {
            NoteListView()
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    NoteMainView()
        .modelContainer(for: Note.self, inMemory: false)
}
