//
//  StatisticsView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.order) private var habits: [Habit]
    
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedPeriod: TimePeriod = .week
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        periodSelector
                        overallStatsSection
                        categoryBreakdownSection
                        habitsPerformanceSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistics")
        }
        .onAppear {
            viewModel.calculateStatistics(habits: habits, period: selectedPeriod)
        }
        .onChange(of: selectedPeriod) { _, newPeriod in
            viewModel.calculateStatistics(habits: habits, period: newPeriod)
        }
    }
    
    private var periodSelector: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var overallStatsSection: some View {
        VStack(spacing: 16) {
            Text("Overall Completion")
                .font(.headline)
                .foregroundColor(.primaryText)
            
            HStack(spacing: 30) {
                StatCardView(
                    title: "Average",
                    value: "\(Int(viewModel.averageCompletion * 100))%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .primaryPearl
                )
                
                StatCardView(
                    title: "Best Day",
                    value: "\(Int(viewModel.bestDayCompletion * 100))%",
                    icon: "star.fill",
                    color: .green
                )
                
                StatCardView(
                    title: "Streak",
                    value: "\(viewModel.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .foregroundColor(.primaryText)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    CategoryStatRow(
                        category: category,
                        completion: viewModel.categoryCompletions[category] ?? 0,
                        count: habits.filter { $0.category == category && $0.isActive }.count
                    )
                }
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
    
    private var habitsPerformanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit Performance")
                .font(.headline)
                .foregroundColor(.primaryText)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(habits.filter { $0.isActive }) { habit in
                    HabitStatRow(
                        habit: habit,
                        completion: viewModel.habitCompletions[habit.id] ?? 0
                    )
                }
                
                if habits.filter({ $0.isActive }).isEmpty {
                    Text("No habits to show")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
}

enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryStatRow: View {
    let category: HabitCategory
    let completion: Double
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(category.color)
                
                Text(category.title)
                    .font(.subheadline)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Text("\(Int(completion * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.secondaryText.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(category.color)
                        .frame(width: geometry.size.width * completion, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
            
            Text("\(count) habit\(count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(12)
    }
}

struct HabitStatRow: View {
    let habit: Habit
    let completion: Double
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(habit.category.color)
                .frame(width: 4, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.subheadline)
                    .foregroundColor(.primaryText)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.secondaryText.opacity(0.2))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(habit.category.color)
                            .frame(width: geometry.size.width * completion, height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            Text("\(Int(completion * 100))%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primaryText)
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(12)
    }
}

