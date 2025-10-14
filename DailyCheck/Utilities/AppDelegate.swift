//
//  AppDelegate.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension AppDelegate {
    static func setOrientationLock(_ orientation: UIInterfaceOrientationMask) {
        orientationLock = orientation
        
        if #available(iOS 16.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            }
        } else {
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

