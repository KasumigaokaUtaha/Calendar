//
//  AppAction.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

/// The data structure for storing all available actions in the redux store.
enum AppAction {
    case setCurrentDate(_ date: Date)
    case setStartOfWeek(_ weekday: Weekday)

    case loadYearDataIfNeeded(base: Int)
    case loadYearData(base: Int, count: Int, direction: Direction)
    case loadYearDataRange(base: Int, range: ClosedRange<Int>)
    case setYearData(_ yearData: YearData)
    case setYearDataCollection(_ yearDataCollection: [YearData])
    case setScrollToToday(withAnimation: Bool)
    case resetScrollToToDay

    // MARK: - Event Actions

    case saveEvent(newEvent: Event)
    case setEventErrorMessage(errorMessage: String)
    case setShowError(show: Bool)
    // MARK: - Year View Actions

    case setSelectedYear(_ year: Int)
    case setSelectedMonth(_ month: Int)

    // MARK: - Route Actions

    case open(_ tab: Tab)
}

enum Direction {
    case past
    case future
}
