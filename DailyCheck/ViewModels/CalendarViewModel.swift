//
//  CalendarViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine
import SwiftData

@MainActor
class CalendarViewModel: ObservableObject {
    
    func calculateOverallProgress(habits: [Habit], date: Date) -> Double {
        let activeHabits = habits.filter { $0.isActive }
        guard !activeHabits.isEmpty else { return 0 }
        
        let completedCount = activeHabits.filter { habit in
            isHabitCompletedOnDate(habit: habit, date: date)
        }.count
        
        let progress = Double(completedCount) / Double(activeHabits.count)
        return progress >= 0.9 ? 1.0 : progress
    }
    
    func calculateCategoryProgress(habits: [Habit], category: HabitCategory, date: Date) -> Double {
        let categoryHabits = habits.filter { $0.isActive && $0.category == category }
        guard !categoryHabits.isEmpty else { return 0 }
        
        let completedCount = categoryHabits.filter { habit in
            isHabitCompletedOnDate(habit: habit, date: date)
        }.count
        
        return Double(completedCount) / Double(categoryHabits.count)
    }
    
    func toggleHabit(habit: Habit, date: Date, modelContext: ModelContext) {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        
        if let existingCompletion = habit.completions.first(where: { completion in
            calendar.isDate(completion.date, inSameDayAs: targetDay)
        }) {
            modelContext.delete(existingCompletion)
        } else {
            let completion = HabitCompletion(date: targetDay)
            completion.habit = habit
            habit.completions.append(completion)
            modelContext.insert(completion)
        }
        
        try? modelContext.save()
    }
    
    private func isHabitCompletedOnDate(habit: Habit, date: Date) -> Bool {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        
        return habit.completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: targetDay)
        }
    }
}

