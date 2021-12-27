//
//  DateData.swift
//  Calendar
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
    var dayData: [DayData?]

    init(month: Int, dayData: [DayData?]) {
        id = UUID()
        self.month = month
        self.dayData = dayData
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
