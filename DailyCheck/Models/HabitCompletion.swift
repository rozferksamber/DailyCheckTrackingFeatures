//
//  HabitCompletion.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var id: UUID
    var date: Date
    var habit: Habit?
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
}

