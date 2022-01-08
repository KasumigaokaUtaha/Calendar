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
    
//    var currentEvent: Event
    
//    var events: [Event]
    var scrollToToday: Bool
    var isScrollToTodayAnimated: Bool

    var isLoadingYearData: Bool

    init() {
        years = [:]
        allYears = []
        currentDate = Date()
        startOfWeek = .sunday
        calendar = Calendar.current
//        currentEvent = Event(name: "Test", startDate: Date(), endDate: Date())
//        events = []
        calendar.locale = Locale.autoupdatingCurrent
        currentYear = calendar.component(.year, from: currentDate)
        isLoadingYearData = false
        scrollToToday = false
        isScrollToTodayAnimated = false
    }
}
