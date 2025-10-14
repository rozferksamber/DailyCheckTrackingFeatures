//
//  Habit.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var habitDescription: String?
    var category: HabitCategory
    var createdAt: Date
    var isActive: Bool
    var order: Int
    
    @Relationship(deleteRule: .cascade)
    var completions: [HabitCompletion]
    
    init(title: String, description: String? = nil, category: HabitCategory, order: Int = 0) {
        self.id = UUID()
        self.title = title
        self.habitDescription = description
        self.category = category
        self.createdAt = Date()
        self.isActive = true
        self.order = order
        self.completions = []
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: today)
        }
    }
    
    func completionCount(for date: Date) -> Int {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        
        return completions.filter { completion in
            calendar.isDate(completion.date, inSameDayAs: targetDay)
        }.count
    }
}

