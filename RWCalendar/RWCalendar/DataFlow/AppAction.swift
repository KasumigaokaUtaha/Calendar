//
//  AppAction.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum AppAction {
    case loadYearData(date: Date, range: ClosedRange<Int>)
    case setCurrentDate(_ date: Date)
    case setStartOfWeek(_ weekday: Weekday)
}
