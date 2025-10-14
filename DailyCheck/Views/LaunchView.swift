//
//  LaunchView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }
}

