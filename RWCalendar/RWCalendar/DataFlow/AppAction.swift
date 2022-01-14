//
//  AppAction.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum AppAction {
    case setCurrentDate(_ date: Date)
    case setStartOfWeek(_ weekday: Weekday)

    case loadYearDataIfNeeded(base: Int)
    case loadYearData(base: Int, count: Int, direction: Direction)
    case loadYearDataRange(base: Int, range: ClosedRange<Int>)
    case setYearData(_ yearData: YearData)
    case setYearDataCollection(_ yearDataCollection: [YearData])
//    case updateEvent(newEvent: EventDTO, id: UUID)
    
//    case updateEvent()
    case setCurrentEvent(_ event: Event?)
    case updateEvent(event: EventDTO, id: UUID)
    case setEventList(eventList: [Event])
    case loadAllEvents
    //    case loadExampleEvent    
//    case insertNewEvent(_ event: Event)

    case setScrollToToday(withAnimation: Bool)
    case resetScrollToDay
    
}

enum Direction {
    case past
    case future
}
