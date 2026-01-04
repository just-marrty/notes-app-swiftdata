//
//  AddNoteView.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    
    @AppStorage("scheme") private var schemeColor: ColorBackground = .gray
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @FocusState private var showKeyboard: Bool
    
    @State private var noteVM = NoteViewModel()
    
    var body: some View {
        VStack {
            TextEditor(text: $noteVM.content)
                .autocorrectionDisabled()
                .scrollDismissesKeyboard(.automatic)
                .focused($showKeyboard)
        }
        .padding()
        .navigationTitle("Add note")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showKeyboard = true
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedContent = noteVM.trimmedContent()
                    let newNote = Note(content: trimmedContent, createdAt: Date())
                    context.insert(newNote)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                } label: {
                    Text("Save")
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
        AddNoteView()
            .modelContainer(for: Note.self, inMemory: false)
    }
}
