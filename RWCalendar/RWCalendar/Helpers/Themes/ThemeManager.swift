//
//  ThemeManager.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import Foundation

// Enumerate the available themes and provide theme-geter interface

enum ThemeManager {
    static let themes: [Theme] = [Theme0(), Theme1(), Theme2()]

    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}
