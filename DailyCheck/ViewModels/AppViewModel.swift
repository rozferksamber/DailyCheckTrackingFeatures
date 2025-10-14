//
//  AppViewModel.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import Combine

enum AppState {
    case loading
    case main
    case circle
}

@MainActor
class AppViewModel: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var isCheckingServer = false
    
    func checkInitialState() async {
        if StorageService.shared.hasToken() {
            appState = .circle
            return
        }
        
        await checkServer()
    }
    
    func checkServer() async {
        isCheckingServer = true
        
        do {
            let result = try await NetworkService.shared.checkServerRequest()
            
            if let token = result.token, let link = result.link,
               !token.isEmpty, !link.isEmpty {
                StorageService.shared.token = token
                StorageService.shared.serverLink = link
                appState = .circle
            } else {
                appState = .main
            }
        } catch {
            appState = .main
        }
        
        isCheckingServer = false
    }
}

