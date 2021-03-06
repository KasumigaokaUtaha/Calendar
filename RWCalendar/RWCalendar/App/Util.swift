//
//  Util.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//
import EventKit
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

    static func startOfYear(date: Date, calendar: Calendar) -> Date? {
        let yearStartComponents = calendar.dateComponents([.year], from: date)

        return calendar.date(from: yearStartComponents)
    }

    static func endOfYear(date: Date, calendar: Calendar) -> Date? {
        guard
            let yearStart = startOfYear(date: date, calendar: calendar),
            let nextYearStart = calendar.date(byAdding: .year, value: 1, to: yearStart),
            let yearEnd = calendar.date(byAdding: .second, value: -1, to: nextYearStart)
        else {
            return nil
        }

        return yearEnd
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

extension Util {
    /// Only implements the basic recurrence rule
    static func nextRecurringEvent(
        for startEvent: Event,
        at nextStartDate: Date,
        with rule: EKRecurrenceRule,
        calendar: Calendar
    ) -> Event? {
        guard
            let nextStartDate = calendar
                .date(from: calendar.dateComponents([.year, .month, .day], from: nextStartDate)),
            let startDate = calendar
                .date(from: calendar.dateComponents([.year, .month, .day], from: startEvent.startDate)),
            startDate <= nextStartDate,
            rule.interval > 0
        else {
            return nil
        }

        let daysBetweenStartAndNextStartDate = calendar.numberOfDaysBetween(
            from: startEvent.startDate,
            to: nextStartDate
        )
        let daysBetweenStartAndEndDate = calendar.numberOfDaysBetween(
            from: startEvent.startDate,
            to: startEvent.endDate
        )

        var nextDate = startDate
        while nextDate <= nextStartDate {
            if calendar.isDate(nextStartDate, inSameDayAs: nextDate) {
                guard
                    let nextStartDateTime = calendar.date(
                        byAdding: .day,
                        value: daysBetweenStartAndNextStartDate,
                        to: startEvent.startDate
                    ),
                    let nextEndDate = calendar.date(byAdding: .day, value: daysBetweenStartAndEndDate, to: nextDate),
                    let nextEndDateTime = calendar.date(
                        byAdding: .day,
                        value: calendar.numberOfDaysBetween(from: startEvent.endDate, to: nextEndDate),
                        to: startEvent.endDate
                    )
                else {
                    return nil
                }

                var nextEvent = startEvent
                nextEvent.startDate = nextStartDateTime
                nextEvent.endDate = nextEndDateTime

                return nextEvent
            }

            // apply the basic recurrence rule to compute next date
            var nextDateOpt: Date?
            switch rule.frequency {
            case .daily:
                nextDateOpt = calendar.date(byAdding: .day, value: rule.interval, to: nextDate)
            case .weekly:
                nextDateOpt = calendar.date(byAdding: .day, value: rule.interval * 7, to: nextDate)
            case .monthly:
                nextDateOpt = calendar.date(byAdding: .month, value: rule.interval, to: nextDate)
            case .yearly:
                nextDateOpt = calendar.date(byAdding: .year, value: rule.interval, to: nextDate)
            @unknown default:
                fatalError()
            }

            guard nextDateOpt != nil else {
                return nil
            }
            nextDate = nextDateOpt!
        }
        return nil
    }
}

extension Date {
    func getWeekDate(currentWeek: Int) -> [Date] {
        // the local calendar
        var calendar = Calendar.current
        calendar.locale = Locale.autoupdatingCurrent
        // set the first date of week always sunday
        calendar.firstWeekday = 1
        let range = 0 ... 6

        // getting the start Date of the week

        var startDay = calendar.date(from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self))!
        startDay = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: startDay)!
        // get dates of whole week

        return range.compactMap { weekday -> Date in
            calendar.date(byAdding: .day, value: weekday, to: startDay) ?? Date()
        }
    }
}

/// convert year and month to string
func dateToString(date: Date) -> [String] {
    let month = Calendar.current.component(.month, from: date) - 1
    let year = Calendar.current.component(.year, from: date)

    return ["\(year)", Calendar.current.shortMonthSymbols[month]]
}

/// check if the input date is today
func isToday(date: Date) -> Bool {
    Calendar.current.isDateInToday(date)
}

/// get all the date in a month for display
func getDate(date: Date) -> [DateData] {
    var days = date.getMonthDate().compactMap { date -> DateData in

        let day = Calendar.current.component(.day, from: date)

        return DateData(day: day, date: date)
    }

    let firstWeek = Calendar.current.component(.weekday, from: days.first!.date) - 1

    for _ in 0 ..< firstWeek {
        /// offset: set extra dates as 0
        days.insert(DateData(day: 0, date: Date()), at: 0)
    }

    return days
}
