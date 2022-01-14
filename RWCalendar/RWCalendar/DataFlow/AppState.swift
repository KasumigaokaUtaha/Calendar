//
//  AppState.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

struct AppState {
    var years: [Int: YearData]
    var months: [Int: MonthData]
    var allDays: [Int]
    var allYears: [Int]
    var currentDate: Date
    var currentMonth: Int
    var currentYear: Int
    var startOfWeek: Weekday
    var calendar: Calendar
    var scrollToToday: Bool
    var isScrollToTodayAnimated: Bool

    var isLoadingYearData: Bool

    init() {
        years = [:]
        months = [:]
        allYears = []
        allDays = []
        currentDate = Date()
        startOfWeek = .sunday
        calendar = Calendar.current
        calendar.locale = Locale.autoupdatingCurrent
        currentYear = calendar.component(.year, from: currentDate)
        currentMonth = calendar.component(.month, from: currentDate)
        isLoadingYearData = false
        scrollToToday = false
        isScrollToTodayAnimated = false
    }
}
