//
//  NoteSettingsView.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import SwiftUI

struct NoteSettingsView: View {
    
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    @AppStorage("scheme") private var schemeColor: ColorBackground = .gray
    
    var body: some View {
        Form {
            Section {
                Toggle(isDarkOn ? "Light mode" : "Dark mode", isOn: $isDarkOn)
                    .tint(.green.opacity(0.3))
            } header: {
                Text("Appearance")
            }
            .listRowBackground(Color.gray.opacity(0.3))
            
            Section {
                Picker("Color scheme", selection: $schemeColor) {
                    ForEach(ColorBackground.allCases, id: \.rawValue) { color in
                        Text(color.rawValue.capitalized)
                            .tag(color)
                    }
                }
            } header: {
                Text("Color scheme")
            }
            .listRowBackground(Color.gray.opacity(0.3))
        }
        .navigationTitle("Settings")
        .scrollContentBackground(.hidden)
        .background {
            schemeColor.scheme.ignoresSafeArea()
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    NavigationStack {
        NoteSettingsView()
    }
}
