//
//  AppState.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

struct AppState {
    var years: [Int: YearData]
    var allYears: [Int]
    var currentDate: Date
    var startOfWeek: Weekday

    init() {
        years = [:]
        allYears = []
        currentDate = Date()
        startOfWeek = .sunday
    }
}
