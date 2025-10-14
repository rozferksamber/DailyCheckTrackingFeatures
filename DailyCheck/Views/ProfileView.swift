//
//  ProfileView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.order) private var habits: [Habit]
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showDeleteConfirmation = false
    @State private var showEditName = false
    @State private var editedName = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        statisticsSummary
                        manageHabitsSection
                        settingsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.calculateStats(habits: habits)
            profileImage = viewModel.userPhoto
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    if let photo = profileImage {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.primaryPearl, .secondaryPearl]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    )
                    .offset(x: -5, y: -5)
            }
            
            HStack(spacing: 8) {
                Text(viewModel.userName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Button(action: {
                    editedName = viewModel.userName
                    showEditName = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            Text("Building better habits daily")
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondaryBackground)
        .cornerRadius(16)
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        profileImage = image
                        viewModel.saveUserPhoto(image)
                    }
                }
            }
        }
        .alert("Edit Name", isPresented: $showEditName) {
            TextField("Name", text: $editedName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if !editedName.trimmingCharacters(in: .whitespaces).isEmpty {
                    viewModel.saveUserName(editedName)
                }
            }
        } message: {
            Text("Enter your name")
        }
    }
    
    private var statisticsSummary: some View {
        VStack(spacing: 12) {
            Text("Your Progress")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                StatItemView(
                    title: "Total Habits",
                    value: "\(viewModel.totalHabits)",
                    icon: "checkmark.circle.fill",
                    color: .primaryPearl
                )
                
                StatItemView(
                    title: "Completions",
                    value: "\(viewModel.totalCompletions)",
                    icon: "star.fill",
                    color: .yellow
                )
            }
            
            HStack(spacing: 12) {
                StatItemView(
                    title: "Current Streak",
                    value: "\(viewModel.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatItemView(
                    title: "Best Streak",
                    value: "\(viewModel.bestStreak)",
                    icon: "trophy.fill",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
    
    private var manageHabitsSection: some View {
        VStack(spacing: 12) {
            Text("Manage Habits")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                ForEach(habits) { habit in
                    ManageHabitRow(
                        habit: habit,
                        onDelete: {
                            deleteHabit(habit)
                        },
                        onToggleActive: {
                            toggleHabitActive(habit)
                        }
                    )
                }
                
                if habits.isEmpty {
                    Text("No habits created yet")
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
    
    private var settingsSection: some View {
        VStack(spacing: 12) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingRow(
                    icon: "trash.fill",
                    title: "Clear All Data",
                    color: .red,
                    action: {
                        showDeleteConfirmation = true
                    }
                )
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(16)
        .alert("Clear All Data", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("This will delete all your habits and their completion history. This action cannot be undone.")
        }
    }
    
    private func deleteHabit(_ habit: Habit) {
        modelContext.delete(habit)
        try? modelContext.save()
        viewModel.calculateStats(habits: habits)
    }
    
    private func toggleHabitActive(_ habit: Habit) {
        habit.isActive.toggle()
        try? modelContext.save()
        viewModel.calculateStats(habits: habits)
    }
    
    private func clearAllData() {
        for habit in habits {
            modelContext.delete(habit)
        }
        try? modelContext.save()
        viewModel.calculateStats(habits: habits)
    }
}

struct StatItemView: View {
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
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(12)
    }
}

struct ManageHabitRow: View {
    let habit: Habit
    let onDelete: () -> Void
    let onToggleActive: () -> Void
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(habit.category.color)
                .frame(width: 4, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.subheadline)
                    .foregroundColor(.primaryText)
                
                Text(habit.category.title)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { habit.isActive },
                set: { _ in onToggleActive() }
            ))
            .labelsHidden()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(12)
        .opacity(habit.isActive ? 1.0 : 0.6)
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            .padding()
            .background(Color.primaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

