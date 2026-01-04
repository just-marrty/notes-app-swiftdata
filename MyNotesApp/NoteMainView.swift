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
    @AppStorage("scheme") private var schemeColor: ColorBackground = .gray
    
    var body: some View {
        NavigationStack {
            NoteListView()
                .navigationTitle("My Notes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddNoteView()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink {
                            NoteSettingsView()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .navigationDestination(for: Note.self) { note in
                    NoteUpdateView(note: note)
                }
                .scrollContentBackground(.hidden)
                .background {
                    schemeColor.scheme.ignoresSafeArea()
                }
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    NoteMainView()
        .modelContainer(for: Note.self, inMemory: false)
}
