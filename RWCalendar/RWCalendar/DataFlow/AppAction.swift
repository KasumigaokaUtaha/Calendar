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

    case loadYearData(date: Date, range: ClosedRange<Int>)
    case setYearData(_ yearData: YearData)
    case setYearDataCollection(_ yearDataCollection: [YearData])
    case updateEvent(newEvent: EventDTO, id: UUID)
    
//    case updateEvent()
//    case setCurrentEvent(_ event: Event)
    
//    case insertNewEvent(_ event: Event)
}
