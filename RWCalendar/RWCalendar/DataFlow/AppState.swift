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
    var currentYear: Int
    var startOfWeek: Weekday
    var calendar: Calendar
    var scrollToToday: Bool
    var isScrollToTodayAnimated: Bool

    var isLoadingYearData: Bool
    
    // States about event
    var currentEvent: Event?
    var showError: Bool
    var errorMessage: String
    var eventList: [Event]
    init() {
        years = [:]
        allYears = []
        currentDate = Date()
        startOfWeek = .sunday
        calendar = Calendar.current
        calendar.locale = Locale.autoupdatingCurrent
        currentYear = calendar.component(.year, from: currentDate)
        isLoadingYearData = false
        scrollToToday = false
        isScrollToTodayAnimated = false
        currentEvent = nil
        showError = false
        errorMessage = ""
        eventList = []
    }
}
