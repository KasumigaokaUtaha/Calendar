//
//  AppState.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import EventKit
import Foundation
import SwiftUI

/// The data structure for storing the state of a redux store.
struct AppState {
    // MARK: - General States

    /// A dictionary containing all computed years data
    var years: [Int: YearData]
    /// A list of all computed years
    var allYears: [Int]
    /// The current date
    var currentDate: Date
    /// The current year
    var currentYear: Int
    /// The start of week, defaults to Sunday
    var startOfWeek: Weekday
    /// The user's calendar
    var calendar: Calendar
    /// A boolean value indicating whether the currently displayed view should scroll back to today
    var scrollToToday: Bool
    /// A boolean value specifying whether the behavior of scrolling back to today should be animated
    var isScrollToTodayAnimated: Bool

    /// A boolean value indicating the status of loading year data
    ///
    /// If this value is true, then it indicates that some computational work is now in progess.
    /// Otherwise, there is no ongoing computational work.
    var isLoadingYearData: Bool

    var showError: Bool
    var showAlert: Bool
    var alertTitle: String
    var errorMessage: String
    var alertMessage: String

    var selectedDate: Date?

    // MARK: - Year Specific States

    /// The currently selected year
    ///
    /// This value may be used when navigating from year view to other views to provide
    /// additional information
    @AppStorage("selectedYear")
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    /// The currently selected month
    ///
    /// This value may be used when navigating from year view to other views to provide
    /// additional information
    @AppStorage("selectedMonth")
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    /// The currently selected day
    ///
    /// This value may be used when navigating from year view to other views to provide
    /// additional information
    @AppStorage("selectedDay")
    var selectedDay: Int = Calendar.current.component(.day, from: Date())

    // MARK: - Route States

    /// Currently displayed tab
    ///
    /// Use this value to determine which tab should be presented.
    @AppStorage("tab")
    var currentTab = Tab.year

    // MARK: - Event States

    var selectedEvent: Event?

    var dateToEventIDs: [RWDate: [String]]
    var eventIDToEvent: [String: Event]
    var allEventIDs: [String]
    var recurringEventIDs: [String]

    @AppStorage("activatedCalendarNames")
    var storedActivatedCalendarNames = Data([])
    var activatedCalendarNames: [String]
    var activatedCalendars: [EKCalendar]

    var defaultEventCalendar: EKCalendar!
    var defaultReminderCalendar: EKCalendar!

    init() {
        years = [:]
        allYears = []
        currentDate = Date()
        startOfWeek = .sunday
        calendar = Calendar.current
        calendar.locale = Locale.autoupdatingCurrent
        currentYear = calendar.component(.year, from: currentDate)

        isLoadingYearData = false

        showAlert = false
        alertTitle = ""
        alertMessage = ""

        scrollToToday = false
        isScrollToTodayAnimated = false
        showError = false
        errorMessage = ""
        dateToEventIDs = [:]
        eventIDToEvent = [:]
        allEventIDs = []
        recurringEventIDs = []

        activatedCalendarNames = []
        activatedCalendars = []
    }
}
