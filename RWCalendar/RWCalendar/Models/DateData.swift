//
//  DateData.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum Weekday: String {
    case monday
    case tuesday
    case thursday
    case wednesday
    case friday
    case saturday
    case sunday

    init?(_ num: Int, calendar: Calendar) {
        guard calendar.identifier == .gregorian else {
            return nil
        }

        switch num {
        case 1:
            self = .sunday
        case 2:
            self = .monday
        case 3:
            self = .tuesday
        case 4:
            self = .wednesday
        case 5:
            self = .thursday
        case 6:
            self = .friday
        case 7:
            self = .saturday
        default:
            return nil
        }
    }
}

struct YearData: Identifiable {
    let id: UUID
    let year: Int
    var months: [Int: MonthData]

    init(year: Int, monthData: [MonthData]) {
        id = UUID()
        self.year = year
        months = monthData.reduce(into: [:]) { dict, monthData in
            dict[monthData.month] = monthData
        }
    }
}

struct MonthData: Identifiable {
    let id: UUID
    let month: Int
    var dayData: [DayData]
    var lastMonthDays: [DayData]
    var nextMonthDays: [DayData]

    init(month: Int, dayData: [DayData], lastMonthDays: [DayData], nextMonthDays: [DayData]) {
        id = UUID()
        self.month = month
        self.dayData = dayData
        self.lastMonthDays = lastMonthDays
        self.nextMonthDays = nextMonthDays
    }
}

struct DayData: Identifiable {
    let id: UUID
    let day: Int
    let weekday: Weekday

    init(day: Int, weekday: Weekday) {
        id = UUID()
        self.day = day
        self.weekday = weekday
    }
}
