//
//  AppEnvironment.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import Foundation

struct AppEnvironment {
    var mainQueue: DispatchQueue
    var backgroundQueue: DispatchQueue

    var year: YearEnvironment

    init() {
        mainQueue = DispatchQueue.main
        backgroundQueue = DispatchQueue.global(qos: .background)

        year = YearEnvironment()
    }
}

struct YearEnvironment {
    func performCalculation(
        date: Date,
        range: ClosedRange<Int>,
        startOfWeek: Weekday,
        calendar: Calendar
    ) -> AnyPublisher<[YearData], Never> {
        Deferred {
            Future { promise in
                let currentYear = calendar.component(
                    .year,
                    from: date
                )
                var allYears: [YearData] = []

                for offset in range {
                    let year = currentYear + offset
                    var months: [MonthData] = []

                    for month in 1 ... 12 {
                        let days = Util.allDaysIn(
                            year: year,
                            month: month,
                            calendar: calendar
                        )?
                            .map {
                                DayData(
                                    date: $0,
                                    calendar: calendar
                                )
                            }
                            .compactMap { $0 } ?? []
                        let lastMonthDays = Util.lastMonthDays(
                            year: year,
                            month: month,
                            startOfWeek: startOfWeek,
                            calendar: calendar
                        )?
                            .map {
                                DayData(
                                    date: $0,
                                    calendar: calendar
                                )
                            }
                            .compactMap { $0 } ?? []
                        let nextMonthDays = Util.nextMonthDays(
                            year: year,
                            month: month,
                            startOfWeek: startOfWeek,
                            calendar: calendar
                        )?
                            .map {
                                DayData(
                                    date: $0,
                                    calendar: calendar
                                )
                            }
                            .compactMap { $0 } ?? []

                        months
                            .append(MonthData(
                                month: month,
                                days: days,
                                lastMonthDays: lastMonthDays,
                                nextMonthDays: nextMonthDays
                            ))
                    }

                    let yearData = YearData(
                        year: year,
                        monthData: months
                    )
                    allYears.append(yearData)
                }

                promise(.success(allYears))
            }
        }
        .eraseToAnyPublisher()
    }
}
