//
//  AppAction.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation
import EventKit

/// The data structure for storing all available actions in the redux store.
enum AppAction {
    // MARK: - General Actions
    case empty

    case setCurrentDate(_ date: Date)
    case setStartOfWeek(_ weekday: Weekday)

    case loadYearDataIfNeeded(base: Int)
    case loadYearData(base: Int, count: Int, direction: Direction)
    case loadYearDataRange(base: Int, range: ClosedRange<Int>)
    case setYearData(_ yearData: YearData)
    case setYearDataCollection(_ yearDataCollection: [YearData])
    case setScrollToToday(withAnimation: Bool)
    case resetScrollToToDay
    
    case setShowAlert(Bool)
    case setAlertTitle(String)
    case setAlertMessage(String)
    
    // MARK: - Event Actions

    case setSelectedEvent(Event)
    case saveEvent(newEvent: Event)
    case setEventErrorMessage(String)
    case setShowError(Bool)
    
    case setActivatedCalendars(_ names: [String])
    case activateCalendar(_ name: String)
    case deactivateCalendar(_ name: String)
    
    case requestAccess(to: EKEntityType)
    // MARK: - Year View Actions

    case setSelectedYear(_ year: Int)
    case setSelectedMonth(_ month: Int)

    // MARK: - Route Actions

    case open(_ tab: Tab)
    
    // MARK: - AppStorage Property Actions
    
    case loadAppStorageProperties
}

enum Direction {
    case past
    case future
}
