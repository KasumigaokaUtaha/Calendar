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

    static func lastDayIn(year: Int, month: Int, calendar: Calendar) -> Date? {
        var nextMonth = month + 1
        var year = year
        if nextMonth > 12 {
            year += 1
            nextMonth = 1
        }

        guard let nextFirstDay = calendar.date(from: DateComponents(year: year, month: nextMonth)) else {
            return nil
        }
        return calendar.date(byAdding: .day, value: -1, to: nextFirstDay)
    }

    static func lastMonthDays(
        year: Int,
        month: Int,
        startOfWeek start: Weekday,
        calendar: Calendar
    ) -> [(Int, Weekday)]? {
        guard
            let firstDay = Util.firstDayIn(year: year, month: month, calendar: calendar),
            let weekday = Weekday(calendar.component(.weekday, from: firstDay), calendar: calendar)
        else {
            return nil
        }

        var lastDays: [(Int, Weekday)] = []
        let amount = weekday.value(base: start) - start.value(base: start)

        guard amount > 0 else {
            return nil
        }

        for offset in (1 ... amount).reversed() {
            guard
                let lastDay = calendar.date(byAdding: .day, value: -offset, to: firstDay),
                let lastWeekday = Weekday(calendar.component(.weekday, from: lastDay), calendar: calendar)
            else {
                return nil
            }

            lastDays.append((calendar.component(.day, from: lastDay), lastWeekday))
        }

        return lastDays
    }

    static func nextMonthDays(
        year: Int,
        month: Int,
        startOfWeek start: Weekday,
        calendar: Calendar
    ) -> [(Int, Weekday)]? {
        guard
            let lastDay = Util.lastDayIn(year: year, month: month, calendar: calendar),
            let weekday = Weekday(calendar.component(.weekday, from: lastDay), calendar: calendar)
        else {
            return nil
        }

        var nextDays: [(Int, Weekday)] = []
        let endOfWeekValue = start.value(base: start) + 6
        let amount = endOfWeekValue - weekday.value(base: start)

        guard amount > 0 else {
            return nil
        }

        for offset in 1 ... amount {
            guard
                let nextDay = calendar.date(byAdding: .day, value: offset, to: lastDay),
                let nextWeekday = Weekday(calendar.component(.weekday, from: nextDay), calendar: calendar)
            else {
                return nil
            }

            nextDays.append((calendar.component(.day, from: nextDay), nextWeekday))
        }

        return nextDays
    }
}
