//
//  DailyCheckApp.swift
//  DailyCheck
//
//  Created by Вадим Дзюба on 12.10.2025.
//

import SwiftUI
import SwiftData

@main
struct DailyCheckApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            HabitCompletion.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appViewModel)
                .modelContainer(sharedModelContainer)
                .task {
                    await appViewModel.checkInitialState()
                }
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        switch appViewModel.appState {
        case .loading:
            LaunchView()
                .onAppear {
                    AppDelegate.setOrientationLock(.portrait)
                }
        case .main:
            MainTabView()
                .onAppear {
                    AppDelegate.setOrientationLock(.portrait)
                }
        case .circle:
            CircleView()
        }
    }
}
