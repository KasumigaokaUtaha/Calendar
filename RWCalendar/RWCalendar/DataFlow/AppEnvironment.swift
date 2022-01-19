//
//  AppEnvironment.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import CoreData
import Foundation

struct AppEnvironment {
    var mainQueue: DispatchQueue
    var backgroundQueue: DispatchQueue

    var year: YearEnvironment
    var event: EventEnvironment

    init() {
        mainQueue = DispatchQueue.main
        backgroundQueue = DispatchQueue.global(qos: .background)

        year = YearEnvironment()
        event = EventEnvironment()
    }
}

struct EventEnvironment {
    var eventsCalendarManager: EventController = .init()

    func addEventToCalendar(_ newEvent: Event) -> AnyPublisher<String, Never> {
        Deferred {
            Future { promise in
                eventsCalendarManager.addEventToCalendar(event: newEvent) { result in
                    switch result {
                    case .success:
                        promise(.success(""))
                    case let .failure(error):
                        switch error {
                        case .denied,
                             .restricted:
                            promise(.success("Calendar access was denied or restricted"))
                        case .notAdded:
                            promise(.success("Event was not added to calendar"))
                        case .alreadyExists:
                            promise(.success("Event already exists in calendar"))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct YearEnvironment {
    func performCalculation(
        currentYear: Int,
        range: ClosedRange<Int>,
        startOfWeek: Weekday,
        calendar: Calendar
    ) -> AnyPublisher<[YearData], Never> {
        Deferred {
            Future { promise in
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
                            .map { DayData(date: $0, calendar: calendar) }
                            .compactMap { $0 } ?? []
                        let lastMonthDays = Util.lastMonthDays(
                            year: year,
                            month: month,
                            startOfWeek: startOfWeek,
                            calendar: calendar
                        )?
                            .map { DayData(date: $0, calendar: calendar) }
                            .compactMap { $0 } ?? []
                        let nextMonthDays = Util.nextMonthDays(
                            year: year,
                            month: month,
                            startOfWeek: startOfWeek,
                            additionalDays: true,
                            calendar: calendar
                        )?
                            .map { DayData(date: $0, calendar: calendar) }
                            .compactMap { $0 } ?? []

                        months.append(MonthData(
                            month: month,
                            days: days,
                            lastMonthDays: lastMonthDays,
                            nextMonthDays: nextMonthDays
                        ))
                    }

                    let yearData = YearData(year: year, monthData: months)
                    allYears.append(yearData)
                }

                promise(.success(allYears))
            }
        }
        .eraseToAnyPublisher()
    }
}
