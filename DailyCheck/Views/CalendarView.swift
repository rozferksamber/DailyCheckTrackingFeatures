//
//  CalendarView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.order) private var habits: [Habit]
    
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showAddHabit = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        datePickerSection
                        progressCirclesSection
                        habitsListSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Daily Check")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddHabit = true }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "plus")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(modelContext: modelContext)
            }
        }
    }
    
    private var datePickerSection: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .accentColor(.primaryPearl)
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(16)
    }
    
    private var progressCirclesSection: some View {
        VStack(spacing: 15) {
            ProgressCircleView(
                progress: viewModel.calculateOverallProgress(habits: habits, date: selectedDate),
                category: nil,
                title: "Overall",
                size: 140
            )
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    ProgressCircleView(
                        progress: viewModel.calculateCategoryProgress(
                            habits: habits,
                            category: category,
                            date: selectedDate
                        ),
                        category: category,
                        title: category.title,
                        size: 100
                    )
                }
            }
        }
    }
    
    private var habitsListSection: some View {
        VStack(spacing: 12) {
            ForEach(habits.filter { $0.isActive }) { habit in
                HabitRowView(
                    habit: habit,
                    date: selectedDate,
                    onToggle: {
                        viewModel.toggleHabit(habit: habit, date: selectedDate, modelContext: modelContext)
                    }
                )
            }
            
            if habits.filter({ $0.isActive }).isEmpty {
                emptyStateView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText.opacity(0.3))
            
            Text("No habits yet")
                .font(.title3)
                .foregroundColor(.secondaryText)
            
            Text("Tap + to add your first habit")
                .font(.caption)
                .foregroundColor(.secondaryText.opacity(0.7))
        }
        .padding(.vertical, 40)
    }
}

struct HabitRowView: View {
    let habit: Habit
    let date: Date
    let onToggle: () -> Void
    
    private var isCompleted: Bool {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        
        return habit.completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: targetDay)
        }
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(habit.category.color)
                .frame(width: 4, height: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                
                if let description = habit.habitDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? habit.category.color : .secondaryText)
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }
}

struct ProgressCircleView: View {
    let progress: Double
    let category: HabitCategory?
    let title: String
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.secondaryText.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        category?.color ?? .primaryPearl,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)
                
                VStack(spacing: 2) {
                    if let category = category {
                        Image(systemName: category.icon)
                            .font(.title3)
                            .foregroundColor(category.color)
                    }
                    
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }
            }
            .frame(width: size, height: size)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
    }
}

