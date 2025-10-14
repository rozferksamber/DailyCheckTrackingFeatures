//
//  MainTabView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            TipsView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(Color(red: 0.4, green: 0.4, blue: 1.0)) // Bright blue-purple
    }
}

