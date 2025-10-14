//
//  StorageService.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "authToken"
    private let linkKey = "serverLink"
    
    private init() {}
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
    
    var serverLink: String? {
        get {
            return userDefaults.string(forKey: linkKey)
        }
        set {
            userDefaults.set(newValue, forKey: linkKey)
        }
    }
    
    func hasToken() -> Bool {
        return token != nil
    }
    
    func clearAll() {
        token = nil
        serverLink = nil
    }
}

