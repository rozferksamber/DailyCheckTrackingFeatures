//
//  StatisticsViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var averageCompletion: Double = 0
    @Published var bestDayCompletion: Double = 0
    @Published var currentStreak: Int = 0
    @Published var categoryCompletions: [HabitCategory: Double] = [:]
    @Published var habitCompletions: [UUID: Double] = [:]
    
    func calculateStatistics(habits: [Habit], period: TimePeriod) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let daysToAnalyze: Int
        switch period {
        case .week:
            daysToAnalyze = 7
        case .month:
            daysToAnalyze = 30
        case .year:
            daysToAnalyze = 365
        }
        
        let activeHabits = habits.filter { $0.isActive }
        guard !activeHabits.isEmpty else {
            resetStatistics()
            return
        }
        
        var dailyCompletions: [Double] = []
        
        for dayOffset in 0..<daysToAnalyze {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            let completedCount = activeHabits.filter { habit in
                isHabitCompletedOnDate(habit: habit, date: date)
            }.count
            
            let completion = Double(completedCount) / Double(activeHabits.count)
            dailyCompletions.append(completion)
        }
        
        averageCompletion = dailyCompletions.isEmpty ? 0 : dailyCompletions.reduce(0, +) / Double(dailyCompletions.count)
        bestDayCompletion = dailyCompletions.max() ?? 0
        currentStreak = calculateStreak(habits: activeHabits)
        
        for category in HabitCategory.allCases {
            let categoryHabits = activeHabits.filter { $0.category == category }
            guard !categoryHabits.isEmpty else {
                categoryCompletions[category] = 0
                continue
            }
            
            var categoryDailyCompletions: [Double] = []
            for dayOffset in 0..<daysToAnalyze {
                guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
                
                let completedCount = categoryHabits.filter { habit in
                    isHabitCompletedOnDate(habit: habit, date: date)
                }.count
                
                let completion = Double(completedCount) / Double(categoryHabits.count)
                categoryDailyCompletions.append(completion)
            }
            
            categoryCompletions[category] = categoryDailyCompletions.isEmpty ? 0 : categoryDailyCompletions.reduce(0, +) / Double(categoryDailyCompletions.count)
        }
        
        for habit in activeHabits {
            var habitDailyCompletions: [Bool] = []
            
            for dayOffset in 0..<daysToAnalyze {
                guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
                habitDailyCompletions.append(isHabitCompletedOnDate(habit: habit, date: date))
            }
            
            let completedDays = habitDailyCompletions.filter { $0 }.count
            habitCompletions[habit.id] = habitDailyCompletions.isEmpty ? 0 : Double(completedDays) / Double(habitDailyCompletions.count)
        }
    }
    
    private func calculateStreak(habits: [Habit]) -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        while true {
            let completedCount = habits.filter { habit in
                isHabitCompletedOnDate(habit: habit, date: currentDate)
            }.count
            
            let completion = Double(completedCount) / Double(habits.count)
            
            if completion >= 0.9 {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func isHabitCompletedOnDate(habit: Habit, date: Date) -> Bool {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        
        return habit.completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: targetDay)
        }
    }
    
    private func resetStatistics() {
        averageCompletion = 0
        bestDayCompletion = 0
        currentStreak = 0
        categoryCompletions = [:]
        habitCompletions = [:]
    }
}

