//
//  AppReducer.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: AppEnvironment
) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case let .loadYearData(date, range):
        let calendar = environment.calendar
        let currentYear = calendar.component(.year, from: date)

        for offset in range {
            let year = currentYear + offset
            var months: [MonthData] = []

            for month in 1 ... 12 {
                let days = Util.allDaysIn(year: year, month: month, calendar: calendar)?
                    .compactMap { $0 }
                    .map { DayData(day: $0.0, weekday: $0.1) } ?? []
                let lastMonthDays = Util.lastMonthDays(
                    year: year,
                    month: month,
                    startOfWeek: state.startOfWeek,
                    calendar: calendar
                )?
                    .compactMap { $0 }
                    .map { DayData(day: $0.0, weekday: $0.1) } ?? []
                let nextMonthDays = Util.nextMonthDays(
                    year: year,
                    month: month,
                    startOfWeek: state.startOfWeek,
                    calendar: calendar
                )?
                    .compactMap { $0 }
                    .map { DayData(day: $0.0, weekday: $0.1) } ?? []

                months
                    .append(MonthData(
                        month: month,
                        days: days,
                        lastMonthDays: lastMonthDays,
                        nextMonthDays: nextMonthDays
                    ))
            }

            let yearData = YearData(year: year, monthData: months)
            state.allYears.append(year)
            state.years.updateValue(yearData, forKey: year)
        }

        state.allYears.sort(by: { $0 < $1 })
    case let .setCurrentDate(date):
        state.currentDate = date
    case let .setStartOfWeek(weekday):
        state.startOfWeek = weekday
    }

    return nil
}
