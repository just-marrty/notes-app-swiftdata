//
//  NoteListView.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 04.01.2026.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    
    @AppStorage("scheme") private var schemeColor: ColorBackground = .gray
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    
    @State private var searchText: String = ""
    @State private var noteVM = NoteViewModel()
    
    var body: some View {
        List(noteVM.search(for: searchText, from: notes)) { note in
            NavigationLink(value: note) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(note.content)
                        .lineLimit(1)
                    Text(note.createdAt.formatted())
                        .foregroundStyle(.secondary)
                }
            }
            .listRowBackground(Capsule()
                .fill(Color.gray.opacity(0.3))
                .padding(4))
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    context.delete(note)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.gray.opacity(0.7))
            }
        }
        .navigationTitle("My Notes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddNoteView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: Note.self) { note in
            NoteUpdateView(note: note)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    NoteSettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            schemeColor.scheme.ignoresSafeArea()
        }
        .searchable(text: $searchText, prompt: "Search your note...")
        .animation(.default, value: searchText)
    }
}

#Preview {
    NavigationStack {
        NoteListView()
            .modelContainer(for: Note.self, inMemory: false)
    }
}
