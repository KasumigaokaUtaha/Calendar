//
//  AppAction.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import EventKit
import Foundation

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

    case setShowError(Bool)
    case setShowAlert(Bool)
    case setAlertTitle(String)
    case setAlertMessage(String)

    // MARK: - Event Actions
    
    case loadEventsForYear(at: Date)
    case loadEventsForMonth(at: Date)
    case loadEventsForWeek(at: Date)
    case loadEventsForDay(at: Date)
    
    case loadSourcesAndCalendars
    case loadStoredCalendars

    case addEvent(Event)
    case updateEvent(with: Event)
    case removeEvent(Event)
    
    /// Add event to the state dateToEventIDs
    case addEventToLocalStore(Event)
    /// Update event stored in the state dateToEventIDs
    case updateEvenInLocalStore(Event)
    /// Remove event stored in the state dateToEventIDs
    case removeEventFromLocalStore(Event)
    
    case setSelectedEvent(Event)
    case setEventErrorMessage(String)
    case setActivatedCalendars([EKCalendar])
    case setActivatedCalendarNames([String])

    case activateCalendar(_ name: String)
    case deactivateCalendar(_ name: String)

    case requestAccess(to: EKEntityType)

    case loadDefaultCalendar(for: EKEntityType)
    case setDefaultCalendar(EKCalendar, for: EKEntityType)

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
