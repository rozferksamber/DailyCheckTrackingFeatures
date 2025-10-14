//
//  TipsView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI

struct TipsView: View {
    @StateObject private var viewModel = TipsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        dailyTipSection
                        categoriesSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Tips")
        }
    }
    
    private var dailyTipSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                
                Text("Tip of the Day")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            
            if let dailyTip = viewModel.dailyTip {
                TipCardView(tip: dailyTip, isHighlighted: true)
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(spacing: 20) {
            ForEach(HabitCategory.allCases, id: \.self) { category in
                CategoryTipsSection(category: category, tips: viewModel.tips(for: category))
            }
        }
    }
}

struct CategoryTipsSection: View {
    let category: HabitCategory
    let tips: [Tip]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(category.color)
                
                Text(category.title)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(tips) { tip in
                    TipCardView(tip: tip, isHighlighted: false)
                }
            }
        }
    }
}

struct TipCardView: View {
    let tip: Tip
    let isHighlighted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: tip.icon)
                    .font(.title3)
                    .foregroundColor(tip.category.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(tip.title)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    Text(tip.content)
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(isHighlighted ? Color.primaryPearl.opacity(0.2) : Color.secondaryBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isHighlighted ? Color.primaryPearl : Color.clear, lineWidth: 2)
        )
    }
}

