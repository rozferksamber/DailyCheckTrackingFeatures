//
//  ColorTheme.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI

extension Color {
    static let pearlLight = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let pearlMedium = Color(red: 0.88, green: 0.89, blue: 0.93)
    static let pearlDark = Color(red: 0.75, green: 0.78, blue: 0.85)
    
    static let primaryPearl = Color(red: 0.85, green: 0.87, blue: 0.92)
    static let secondaryPearl = Color(red: 0.78, green: 0.82, blue: 0.88)
    static let adaptivePearl = Color(light: .pearlLight, dark: Color(red: 0.2, green: 0.21, blue: 0.25))
    static let adaptivePearlSecondary = Color(light: .pearlMedium, dark: Color(red: 0.15, green: 0.16, blue: 0.20))
    static let primaryBackground = Color(light: .white, dark: Color(red: 0.1, green: 0.1, blue: 0.12))
    static let secondaryBackground = Color(light: Color(red: 0.95, green: 0.95, blue: 0.97), dark: Color(red: 0.15, green: 0.15, blue: 0.17))
    static let primaryText = Color(light: .black, dark: .white)
    static let secondaryText = Color(light: .gray, dark: Color(red: 0.7, green: 0.7, blue: 0.7))
    
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}

