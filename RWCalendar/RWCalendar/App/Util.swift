//
//  Util.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum Util {
    static func allDaysIn(year: Int, month: Int, calendar: Calendar) -> [(Int, Weekday)]? {
        guard
            let firstDay = Util.firstDayIn(year: year, month: month, calendar: calendar),
            let daysRange = calendar.range(of: .day, in: .month, for: firstDay)
        else {
            return nil
        }

        let daysCount = daysRange.count
        var allDays: [(Int, Weekday)] = []
        for dayOffset in 0 ..< daysCount {
            guard
                let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDay),
                let weekday = Weekday(calendar.component(.weekday, from: date), calendar: calendar)
            else {
                return nil
            }
            allDays.append((dayOffset + 1, weekday))
        }

        return allDays
    }

    static func firstDayIn(year: Int, month: Int, calendar: Calendar) -> Date? {
        calendar.date(from: DateComponents(year: year, month: month))
    }
}
