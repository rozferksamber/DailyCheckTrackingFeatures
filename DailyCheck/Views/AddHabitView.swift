//
//  AddHabitView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    let modelContext: ModelContext
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: HabitCategory = .health
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Details") {
                    TextField("Title", text: $title)
                    
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(HabitCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.title)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    // Category preview
                    HStack {
                        Image(systemName: selectedCategory.icon)
                            .foregroundColor(selectedCategory.color)
                        Text(selectedCategory.title)
                            .foregroundColor(.primaryText)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let habit = Habit(
            title: title,
            description: description.isEmpty ? nil : description,
            category: selectedCategory
        )
        
        modelContext.insert(habit)
        try? modelContext.save()
        dismiss()
    }
}

