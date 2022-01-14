//
//  Util.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum Util {
    static func allDaysIn(year: Int, month: Int, calendar: Calendar) -> [Date]? {
        guard
            let firstDay = Util.firstDayIn(year: year, month: month, calendar: calendar),
            let daysRange = calendar.range(of: .day, in: .month, for: firstDay)
        else {
            return nil
        }

        let daysCount = daysRange.count
        var allDays: [Date] = []
        for dayOffset in 0 ..< daysCount {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDay) else {
                return nil
            }
            allDays.append(date)
        }

        return allDays
    }

    static func numberOfDaysIn(year: Int, month: Int, calendar: Calendar) -> Int? {
        guard
            let firstDay = Util.firstDayIn(year: year, month: month, calendar: calendar),
            let daysRange = calendar.range(of: .day, in: .month, for: firstDay)
        else {
            return nil
        }

        return daysRange.count
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
    ) -> [Date]? {
        guard
            let firstDay = Util.firstDayIn(year: year, month: month, calendar: calendar),
            let weekday = Weekday(calendar.component(.weekday, from: firstDay), calendar: calendar)
        else {
            return nil
        }

        var lastDays: [Date] = []
        let amount = weekday.value(base: start) - start.value(base: start)

        guard amount > 0 else {
            return []
        }

        for offset in (1 ... amount).reversed() {
            guard let lastDay = calendar.date(byAdding: .day, value: -offset, to: firstDay) else {
                return nil
            }

            lastDays.append(lastDay)
        }

        return lastDays
    }

    static func nextMonthDays(
        year: Int,
        month: Int,
        startOfWeek start: Weekday,
        additionalDays: Bool,
        calendar: Calendar
    ) -> [Date]? {
        guard
            let lastDay = Util.lastDayIn(year: year, month: month, calendar: calendar),
            let weekday = Weekday(calendar.component(.weekday, from: lastDay), calendar: calendar)
        else {
            return nil
        }

        var nextDays: [Date] = []
        let endOfWeekValue = start.value(base: start) + 6
        var amount = endOfWeekValue - weekday.value(base: start)

        if additionalDays {
            guard
                let lastMonthDays = Util.lastMonthDays(
                    year: year,
                    month: month,
                    startOfWeek: start,
                    calendar: calendar
                ),
                let numberOfDays = Util.numberOfDaysIn(year: year, month: month, calendar: calendar)
            else {
                return nil
            }

            let numberOfWeeks = 6
            let numberOfWeekdays = 7
            amount = numberOfWeeks * numberOfWeekdays - lastMonthDays.count - numberOfDays
        }

        guard amount > 0 else {
            return []
        }

        for offset in 1 ... amount {
            guard let nextDay = calendar.date(byAdding: .day, value: offset, to: lastDay) else {
                return nil
            }

            nextDays.append(nextDay)
        }

        return nextDays
    }
}