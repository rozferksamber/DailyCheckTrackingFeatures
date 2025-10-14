//
//  ProfileStorageService.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import UIKit

class ProfileStorageService {
    static let shared = ProfileStorageService()
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "userName"
    private let userPhotoKey = "userPhoto"
    
    private init() {}
    
    var userName: String {
        get {
            return userDefaults.string(forKey: userNameKey) ?? "User"
        }
        set {
            userDefaults.set(newValue, forKey: userNameKey)
        }
    }
    
    var userPhoto: UIImage? {
        get {
            guard let data = userDefaults.data(forKey: userPhotoKey) else { return nil }
            return UIImage(data: data)
        }
        set {
            if let image = newValue,
               let data = image.jpegData(compressionQuality: 0.8) {
                userDefaults.set(data, forKey: userPhotoKey)
            } else {
                userDefaults.removeObject(forKey: userPhotoKey)
            }
        }
    }
}

