//
//  NoteUpdateView.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import SwiftUI
import SwiftData

struct NoteUpdateView: View {
    
    @AppStorage("scheme") private var schemeColor: ColorBackground = .gray
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @FocusState private var showKeyBoard: Bool
    
    @State private var noteVM = NoteViewModel()
    
    let note: Note
    
    var body: some View {
        VStack {
            TextEditor(text: $noteVM.content)
                .autocorrectionDisabled()
                .scrollDismissesKeyboard(.automatic)
                .focused($showKeyBoard)
        }
        .padding()
        .navigationTitle("Edit note")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            noteVM.content = note.content
            showKeyBoard = true
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedContent = noteVM.trimmedContent()
                    note.content = trimmedContent
                    note.createdAt = Date()
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                } label: {
                    Text("Update")
                }
                .disabled(!noteVM.isNoteValid())
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            schemeColor.scheme.ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        NoteUpdateView(note: Note(content: "", createdAt: Date()))
            .modelContainer(for: Note.self, inMemory: false)
    }
}
