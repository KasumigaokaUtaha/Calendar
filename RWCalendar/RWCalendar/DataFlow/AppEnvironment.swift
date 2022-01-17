//
//  AppEnvironment.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import CoreData
import Foundation

/// The data structure for storing environment values in the redux store
struct AppEnvironment {
    var mainQueue: DispatchQueue
    var backgroundQueue: DispatchQueue

    var year: YearEnvironment

    var eventController: EventEnvironment

    init() {
        mainQueue = DispatchQueue.main
        backgroundQueue = DispatchQueue.global(qos: .background)

        year = YearEnvironment()
        eventController = EventEnvironment()
    }
}

struct EventEnvironment {
    let dataController: DataController = DataController()

    func createEvent(event: EventDTO) {
        dataController.saveEvent(event)
    }

    func updateEvent(event: EventDTO, id: UUID) -> AnyPublisher<Event?, Error> {
        Deferred {
            Future { promise in
                do {
                    let updatedEvent = try dataController.updateEvent(event, id: id)
                    promise(.success(updatedEvent))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func getAllEvents() -> AnyPublisher<[Event], Never> {
        Deferred { Future {
            promise in
            let events = dataController.getAllEvents()
            promise(.success(events))
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
