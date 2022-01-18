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

    /// Get the weekday unit value with monday as the start of a week
    func value() -> Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }

    /// Get the weekday unit value with given base as the start of a week
    func value(base: Weekday) -> Int {
        var offset: Int = -1

        switch base {
        case .monday:
            offset = 0
        case .tuesday:
            offset = 1
        case .wednesday:
            offset = 2
        case .thursday:
            offset = 3
        case .friday:
            offset = 4
        case .saturday:
            offset = 5
        case .sunday:
            offset = 6
        }

        let value = value() - offset
        return value < 1 ? value + 7 : value
    }
}

struct YearData: Identifiable {
    let id = UUID()
    let year: Int
    var months: [Int: MonthData]

    init(year: Int, monthData: [MonthData]) {
        self.year = year
        months = monthData
            .reduce(into: [:]) { dict, monthData in
                dict[monthData.month] = monthData
            }
    }
}

struct MonthData: Identifiable {
    let id = UUID()
    let month: Int
    var days: [DayData]
    var lastMonthDays: [DayData]
    var nextMonthDays: [DayData]

    init(
        month: Int,
        days: [DayData],
        lastMonthDays: [DayData],
        nextMonthDays: [DayData]
    ) {
        self.month = month
        self.days = days
        self.lastMonthDays = lastMonthDays
        self.nextMonthDays = nextMonthDays
    }
}

struct DayData: Identifiable {
    let id: UUID = UUID()
    let day: Int
    let date: Date
    let weekday: Weekday

    init(day: Int, date: Date, weekday: Weekday) {
        self.day = day
        self.date = date
        self.weekday = weekday
    }

    init?(date: Date, calendar: Calendar) {
        guard
            let weekday = Weekday(
                calendar.component(.weekday, from: date),
                calendar: calendar
            )
        else {
            return nil
        }

        day = calendar.component(.day, from: date)
        self.date = date
        self.weekday = weekday
    }
}


struct DateData: Identifiable{
    var day: Int
    var date: Date
    var id =  UUID().uuidString
    
}
