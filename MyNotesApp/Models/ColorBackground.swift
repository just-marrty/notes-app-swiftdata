//
//  ColorBackground.swift
//  MyNotesApp
//
//  Created by Martin Hrbáček on 03.01.2026.
//

import Foundation
import SwiftUI

enum ColorBackground: String, CaseIterable {
    case gray = "default"
    case blue = "blue"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case indigo = "indigo"
    
    var scheme: Color {
        switch self {
        case .gray:
            return Color.gray.opacity(0.3)
        case .blue:
            return Color.blue.opacity(0.5)
        case .orange:
            return Color.orange.opacity(0.5)
        case .yellow:
            return Color.yellow.opacity(0.5)
        case .green:
            return Color.green.opacity(0.5)
        case .indigo:
            return Color.indigo.opacity(0.5)
        }
    }
}

