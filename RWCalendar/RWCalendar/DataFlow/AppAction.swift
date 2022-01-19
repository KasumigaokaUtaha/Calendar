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
    case setCurrentEvent(_ event: Event?)
    case updateEvent(event: EventDTO, id: UUID)
    case setEventList(eventList: [Event])
    case loadAllEvents
    case setScrollToToday(withAnimation: Bool)
    case resetScrollToToDay

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
