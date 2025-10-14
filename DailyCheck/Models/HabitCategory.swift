//
//  HabitCategory.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import SwiftUI

enum HabitCategory: String, Codable, CaseIterable {
    case health = "Health"
    case work = "Work"
    case selfDevelopment = "Self Development"
    case goals = "Goals"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .health:
            return "heart.fill"
        case .work:
            return "briefcase.fill"
        case .selfDevelopment:
            return "book.fill"
        case .goals:
            return "target"
        }
    }
    
    var color: Color {
        switch self {
        case .health:
            return .red
        case .work:
            return .blue
        case .selfDevelopment:
            return .purple
        case .goals:
            return .green
        }
    }
}

