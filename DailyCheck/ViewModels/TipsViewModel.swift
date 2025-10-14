//
//  TipsViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let category: HabitCategory
    let icon: String
}

@MainActor
class TipsViewModel: ObservableObject {
    @Published var dailyTip: Tip?
    
    private let allTips: [Tip] = [
        Tip(
            title: "Start Your Day with Water",
            content: "Drinking a glass of water first thing in the morning helps kickstart your metabolism and hydrate your body after sleep.",
            category: .health,
            icon: "drop.fill"
        ),
        Tip(
            title: "Take Regular Breaks",
            content: "Every 30 minutes, stand up and stretch for a few minutes. This improves circulation and reduces fatigue.",
            category: .health,
            icon: "figure.walk"
        ),
        Tip(
            title: "Get Quality Sleep",
            content: "Aim for 7-9 hours of sleep. Keep your bedroom cool, dark, and quiet for better rest.",
            category: .health,
            icon: "moon.fill"
        ),
        Tip(
            title: "Practice Mindful Eating",
            content: "Eat slowly and without distractions. This helps you recognize when you're full and improves digestion.",
            category: .health,
            icon: "leaf.fill"
        ),
        Tip(
            title: "Use the 2-Minute Rule",
            content: "If a task takes less than 2 minutes, do it immediately. This prevents small tasks from piling up.",
            category: .work,
            icon: "clock.fill"
        ),
        Tip(
            title: "Plan Your Day",
            content: "Spend 10 minutes each morning planning your top 3 priorities. This keeps you focused on what matters most.",
            category: .work,
            icon: "list.bullet"
        ),
        Tip(
            title: "Batch Similar Tasks",
            content: "Group similar tasks together and complete them in one session. This reduces context switching and improves efficiency.",
            category: .work,
            icon: "square.stack.fill"
        ),
        Tip(
            title: "Time Block Your Calendar",
            content: "Schedule specific blocks of time for focused work, meetings, and breaks. Treat these blocks as important appointments.",
            category: .work,
            icon: "calendar"
        ),
        Tip(
            title: "Read Daily",
            content: "Even 15 minutes of reading each day adds up to significant knowledge over time. Choose books that challenge and inspire you.",
            category: .selfDevelopment,
            icon: "book.fill"
        ),
        Tip(
            title: "Learn Something New",
            content: "Dedicate time each week to learning a new skill. Consistent small efforts lead to mastery over time.",
            category: .selfDevelopment,
            icon: "graduationcap.fill"
        ),
        Tip(
            title: "Practice Gratitude",
            content: "Write down three things you're grateful for each day. This simple practice improves mood and overall well-being.",
            category: .selfDevelopment,
            icon: "heart.fill"
        ),
        Tip(
            title: "Reflect Weekly",
            content: "Spend time each week reflecting on your progress, challenges, and lessons learned. Adjust your approach as needed.",
            category: .selfDevelopment,
            icon: "text.quote"
        ),
        Tip(
            title: "Make Goals Specific",
            content: "Instead of 'exercise more', set a specific goal like 'exercise 30 minutes, 4 times per week'. Specific goals are easier to track.",
            category: .goals,
            icon: "scope"
        ),
        Tip(
            title: "Break Big Goals Down",
            content: "Divide large goals into smaller, manageable milestones. This makes progress visible and maintains motivation.",
            category: .goals,
            icon: "chart.bar.fill"
        ),
        Tip(
            title: "Track Your Progress",
            content: "Regularly review your progress toward goals. Celebrate small wins and adjust strategies when needed.",
            category: .goals,
            icon: "chart.line.uptrend.xyaxis"
        ),
        Tip(
            title: "Share Your Goals",
            content: "Tell someone about your goals. Accountability to others increases your commitment and likelihood of success.",
            category: .goals,
            icon: "person.2.fill"
        )
    ]
    
    init() {
        selectDailyTip()
    }
    
    func tips(for category: HabitCategory) -> [Tip] {
        return allTips.filter { $0.category == category }
    }
    
    private func selectDailyTip() {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % allTips.count
        dailyTip = allTips[index]
    }
}

