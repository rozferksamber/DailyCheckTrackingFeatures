//
//  ProfileViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine
import UIKit

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var totalHabits: Int = 0
    @Published var totalCompletions: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var userName: String = ""
    @Published var userPhoto: UIImage?
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        userName = ProfileStorageService.shared.userName
        userPhoto = ProfileStorageService.shared.userPhoto
    }
    
    func saveUserName(_ name: String) {
        userName = name
        ProfileStorageService.shared.userName = name
    }
    
    func saveUserPhoto(_ image: UIImage?) {
        userPhoto = image
        ProfileStorageService.shared.userPhoto = image
    }
    
    func calculateStats(habits: [Habit]) {
        totalHabits = habits.filter { $0.isActive }.count
        
        var completionsCount = 0
        for habit in habits {
            completionsCount += habit.completions.count
        }
        totalCompletions = completionsCount
        
        currentStreak = calculateCurrentStreak(habits: habits)
        bestStreak = max(currentStreak, bestStreak)
    }
    
    private func calculateCurrentStreak(habits: [Habit]) -> Int {
        let calendar = Calendar.current
        let activeHabits = habits.filter { $0.isActive }
        
        guard !activeHabits.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        while true {
            let completedCount = activeHabits.filter { habit in
                isHabitCompletedOnDate(habit: habit, date: currentDate)
            }.count
            
            let completion = Double(completedCount) / Double(activeHabits.count)
            
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
}

