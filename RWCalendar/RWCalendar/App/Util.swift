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

    static func startOfDay(_ day: Date, calendar: Calendar) -> Date? {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: day)
    }

    static func endOfDay(_ day: Date, calendar: Calendar) -> Date? {
        guard
            let startOfDay = startOfDay(day, calendar: calendar),
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay),
            let endOfDay = calendar.date(byAdding: .second, value: -1, to: startOfNextDay)
        else {
            return nil
        }

        return endOfDay
    }

    static func startOfWeek(date: Date, calendar: Calendar) -> Date? {
        var result = date

        while calendar.component(.weekday, from: result) != calendar.firstWeekday {
            guard let tempDate = calendar.date(byAdding: .day, value: -1, to: result) else {
                return nil
            }

            result = tempDate
        }

        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: result)
    }

    static func endOfWeek(date: Date, calendar: Calendar) -> Date? {
        guard
            let startOfWeek = startOfWeek(date: date, calendar: calendar),
            let startOfNextWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek),
            let endOfWeek = calendar.date(byAdding: .second, value: -1, to: startOfNextWeek)
        else {
            return nil
        }

        return endOfWeek
    }

    static func startOfMonth(date: Date, calendar: Calendar) -> Date? {
        let monthStartComponents = calendar.dateComponents([.year, .month], from: date)

        return calendar.date(from: monthStartComponents)
    }

    static func endOfMonth(date: Date, calendar: Calendar) -> Date? {
        guard
            let monthStart = startOfMonth(date: date, calendar: calendar),
            let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart),
            let monthEnd = calendar.date(byAdding: .second, value: -1, to: nextMonthStart)
        else {
            return nil
        }

        return monthEnd
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

/*
  Helping functions that used for TrueMonthView
 ********************************************************************************/

extension Date {
    func getMonthDate() -> [Date] {
        let range = Calendar.current.range(of: .day, in: .month, for: self)!

        let starter = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!

        return range.compactMap { day -> Date in
            Calendar.current.date(byAdding: .day, value: day - 1, to: starter)!
        }
    }
}

// convert year and month to string
func dateToString(date: Date) -> [String] {
    let month = Calendar.current.component(.month, from: date) - 1
    let year = Calendar.current.component(.year, from: date)

    return ["\(year)", Calendar.current.shortMonthSymbols[month]]
}

// check if the input date is today
func isToday(date: Date) -> Bool {
    Calendar.current.isDateInToday(date)
}

// return current month based on the int value
//func getCurMonth(value: Int) -> Date {
//    Calendar.current.date(byAdding: .month, value: value, to: Date())!
//}

// get all the date in a month for display
func getDate(date: Date) -> [DateData] {
    var days = date.getMonthDate().compactMap { date -> DateData in

        let day = Calendar.current.component(.day, from: date)

        return DateData(day: day, date: date)
    }

    let firstWeek = Calendar.current.component(.weekday, from: days.first!.date)

    for _ in 0 ..< firstWeek - 1 {
        // offset: set extra dates as 0
        days.insert(DateData(day: 0, date: Date()), at: 0)
    }

    return days
}

/*
 Helping functions that used for TrueMonthView
 ******************************************************************************/
