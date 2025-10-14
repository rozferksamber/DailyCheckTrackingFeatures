//
//  CircleViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine

@MainActor
class CircleViewModel: ObservableObject {
    @Published var serverLink: String = ""
    @Published var isLoading: Bool = true
    
    func loadLink() {
        if let link = StorageService.shared.serverLink, !link.isEmpty {
            serverLink = link
        }
    }
}

