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
    var calendar: Calendar
    
//    var currentEvent: Event
    
//    var events: [Event]

    init() {
        years = [:]
        allYears = []
        currentDate = Date()
        startOfWeek = .sunday
        calendar = Calendar.current
//        currentEvent = Event(name: "Test", startDate: Date(), endDate: Date())
//        events = []
    }
}
