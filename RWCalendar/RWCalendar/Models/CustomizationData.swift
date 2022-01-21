//
//  CustomizationData.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import SwiftUI

class CustomizationData: ObservableObject {
    @Published var selectedTheme: Theme = Theme0()
    
    // Store the user customization preference
    @AppStorage("savedThemeChoice") var savedThemeChoice = 0 {
        didSet {
            updateTheme()
        }
    }
    @AppStorage("savedFontSize") var savedFontSize = 17
    @AppStorage("savedFontStyle") var savedFontStyle = "Times New Roman"
    @AppStorage("savedAppIcon") var savedAppIcon = "Default" {
        didSet {
            updateIcon()
        }
    }
    
    init() {
        updateTheme()
    }
    
    func updateTheme() {
        selectedTheme = ThemeManager.getTheme(savedThemeChoice)
    }
    
    func updateIcon() {
        if savedAppIcon == "Default" {
            UIApplication.shared.setAlternateIconName(nil)
        }
        else {
            UIApplication.shared.setAlternateIconName(savedAppIcon)
        }
    }

}
