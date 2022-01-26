//
//  AppEnvironment.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import EventKit
import Foundation

/// The data structure for storing environment values in the redux store
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
    private let eventStore: EKEventStore = .init()

    /// A wrapper function that first determines the authorization status
    /// and then produces a publisher containing the AppActions to perform with regard to the given closure.
    ///
    /// If it is authorized, then this function evaluated the given closure to produce the desired AppAction publisher.
    /// Otherwise, this function produces a publisher with a series of AppAction to handle the corresponding cases.
    private func makeActions(with builder: @escaping () -> Future<[AppAction], Never>)
        -> AnyPublisher<AppAction, Never>
    {
        let publisher = authorizationStatus(for: .event)
        guard publisher == nil else {
            return publisher!
        }

        return Deferred {
            builder()
                .flatMap { (actions: [AppAction]) -> AnyPublisher<AppAction, Never> in
                    actions.publisher.flatMap { Just($0) }.eraseToAnyPublisher()
                }
        }
        .eraseToAnyPublisher()
    }

    /// Request access to the given EKEntityType.
    func requestAccess(to entityType: EKEntityType) -> AnyPublisher<AppAction, Never> {
        Deferred {
            Future { promise in
                eventStore.requestAccess(to: entityType) { granted, error in
                    guard error == nil else {
                        let actions = [
                            AppAction.setAlertTitle("Request Access Failed"),
                            AppAction
                                .setEventErrorMessage(
                                    "Some internal errors happened. Please send an email with the log to our support email address."
                                ),
                            AppAction.setShowError(true)
                        ]
                        promise(.success(actions))
                        return
                    }

                    let actions: [AppAction]
                    if !granted {
                        actions = [
                            AppAction.setAlertTitle("Access Denied"),
                            AppAction
                                .setAlertMessage(
                                    "This app won't work without access rights to your calendar events. Please grant this app access rights in the system settings and try againt later."
                                ),
                            AppAction.setShowAlert(true)
                        ]
                    } else {
                        // Access granted
                        actions = [AppAction.empty]
                    }

                    promise(.success(actions))
                }
            }
            .flatMap { (actions: [AppAction]) -> AnyPublisher<AppAction, Never> in
                actions.publisher.flatMap { Just($0) }.eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

    /// Returns the authentication status for the given EKEntityType.
    ///
    /// If this app is authorized, it returns nil. Otherwise, it returns a publisher with a series of AppAction to perform.
    func authorizationStatus(for entityType: EKEntityType = .event) -> AnyPublisher<AppAction, Never>? {
        let result: AnyPublisher<AppAction, Never>?

        switch EKEventStore.authorizationStatus(for: entityType) {
        case .authorized:
            // The app is authorized to access the service.
            result = nil
        case .denied:
            // The user explicitly denied access to the service for the app.
            result = [
                AppAction.setAlertTitle("Access denied"),
                AppAction
                    .setAlertMessage(
                        "This app won't work without access rights to your calendar events. Please grant this app access rights in the system settings and try againt later."
                    ),
                AppAction.setShowAlert(true)
            ]
            .publisher
            .flatMap { Just($0) }
            .eraseToAnyPublisher()
        case .notDetermined:
            // The user has not yet made a choice regarding whether the app may access the service.
            result = Just(AppAction.requestAccess(to: entityType))
                .eraseToAnyPublisher()
        case .restricted:
            // The user cannot change this app’s authorization status, possibly due to active restrictions such as parental controls being in place.
            result = [
                AppAction.setAlertTitle("Restricted Access"),
                AppAction
                    .setAlertMessage(
                        "You are in restricted mode which means you cannot grant this app access rights to your calendar events. Please try again later."
                    ),
                AppAction.setShowAlert(true)
            ]
            .publisher
            .flatMap { Just($0) }
            .eraseToAnyPublisher()
        @unknown default:
            fatalError()
        }

        return result
    }

    func getDefaultCalendar(for entityType: EKEntityType = .event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                var defaultCalendar: EKCalendar
                switch entityType {
                case .event:
                    defaultCalendar = eventStore.defaultCalendarForNewEvents ?? EKCalendar(
                        for: entityType,
                        eventStore: eventStore
                    )
                case .reminder:
                    defaultCalendar = eventStore
                        .defaultCalendarForNewReminders() ?? EKCalendar(for: entityType, eventStore: eventStore)
                @unknown default:
                    fatalError()
                }

                promise(.success([.setDefaultCalendar(defaultCalendar, for: entityType)]))
            }
        }
    }

    /// Returns all calendar sources.
    func getAllSources() -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                let sources = eventStore.sources
                    .sorted(by: { $0.title.localizedStandardCompare($1.title) == .orderedAscending })
                let actions: [AppAction] = [.setAllSources(sources)]
                promise(.success(actions))
            }
        }
    }

    /// Returns a dictionary from calendar source to array of calendar.
    func getSourceToCalendars(for entityType: EKEntityType = .event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                var result: [EKSource: [EKCalendar]] = [:]
                for source in eventStore.sources {
                    result.updateValue(Array(source.calendars(for: entityType)), forKey: source)
                }

                let actions: [AppAction] = [.setSourceToCalendars(result)]
                promise(.success(actions))
            }
        }
    }

    /// Returns a dictionary from calendar source title to array of sorted calendar titles.
    func getSourceTitleToCalendarTitles(for entityType: EKEntityType = .event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                var result: [String: [String]] = [:]
                for source in eventStore.sources {
                    let calendarTitles = source.calendars(for: entityType).map(\.title)
                    result.updateValue(
                        calendarTitles.sorted { $0.localizedStandardCompare($1) == .orderedAscending },
                        forKey: source.title
                    )
                }

                let actions: [AppAction] = [.setSourceTitleToCalendarTitles(result)]
                promise(.success(actions))
            }
        }
    }

    private func addEventsMatching(
        withStart start: Date,
        end: Date,
        calendars: [EKCalendar]?
    ) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
                let events: [Event] = eventStore.events(matching: predicate).map { .init(ekEvent: $0) }

                let actions: [AppAction] = events.map { event in .updateEventInLocalStore(event) }

                promise(.success(actions))
            }
        }
    }

    /// Adds all events in the given EKCalendars that fall in the given date.
    func addEventsForDay(
        _ day: Date,
        calendar: Calendar,
        with activatedCalendars: [EKCalendar]?
    ) -> AnyPublisher<AppAction, Never> {
        guard
            let startOfDay = Util.startOfDay(day, calendar: calendar),
            let endOfDay = Util.endOfDay(day, calendar: calendar)
        else {
            return Just(AppAction.empty).eraseToAnyPublisher()
        }

        return addEventsMatching(withStart: startOfDay, end: endOfDay, calendars: activatedCalendars)
    }

    /// Adds all events in the given EKCalendars that fall in the week of the given date.
    func addEventsForWeek(
        date: Date,
        calendar: Calendar,
        with activatedCalendars: [EKCalendar]?
    ) -> AnyPublisher<AppAction, Never> {
        guard
            let startOfWeek = Util.startOfWeek(date: date, calendar: calendar),
            let endOfWeek = Util.endOfWeek(date: date, calendar: calendar)
        else {
            return Just(AppAction.empty).eraseToAnyPublisher()
        }

        return addEventsMatching(withStart: startOfWeek, end: endOfWeek, calendars: activatedCalendars)
    }

    /// Adds all events in the given EKCalendars that fall in the month of the given date.
    func addEventsForMonth(
        date: Date,
        calendar: Calendar,
        with activatedCalendars: [EKCalendar]?
    ) -> AnyPublisher<AppAction, Never> {
        guard
            let startOfMonth = Util.startOfMonth(date: date, calendar: calendar),
            let endOfMonth = Util.endOfMonth(date: date, calendar: calendar)
        else {
            return Just(AppAction.empty).eraseToAnyPublisher()
        }

        return addEventsMatching(withStart: startOfMonth, end: endOfMonth, calendars: activatedCalendars)
    }

    /// Adds all events in the given EKCalendars that fall in the year of the given date.
    func addEventsForYear(
        date: Date,
        calendar: Calendar,
        with activatedCalendars: [EKCalendar]?
    ) -> AnyPublisher<AppAction, Never> {
        guard
            let startOfYear = Util.startOfYear(date: date, calendar: calendar),
            let endOfYear = Util.endOfYear(date: date, calendar: calendar)
        else {
            return Just(AppAction.empty).eraseToAnyPublisher()
        }

        return addEventsMatching(withStart: startOfYear, end: endOfYear, calendars: activatedCalendars)
    }

    func searchEventsByName(str: String, events: [Event]) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                var keyArray = str.components(separatedBy: " ")
                for i in keyArray.indices {
                    keyArray[i] = keyArray[i].trimmingCharacters(in: .whitespacesAndNewlines)
                }

                let predicates = keyArray.map { (key: String) -> NSPredicate in
                    NSPredicate(format: "title CONTAINS[c] %@", key)
                }
                let predicateForAllKeys = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                let result = NSArray(array: events).filtered(using: predicateForAllKeys)

                if let filteredEvents = result as NSArray as? [Event] {
                    let actions: [AppAction] = [.setSearchResult(filteredEvents)]
                    promise(.success(actions))
                } else {
                    let actions: [AppAction] = [.setSearchResult([])]
                    promise(.success(actions))
                }
            }
        }
    }

    /// Add the given event to the default EventStore and directly commit the changes.
    func addEvent(_ event: Event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                let newEvent = EKEvent(event: event, eventStore: eventStore)

                do {
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                    let actions: [AppAction] = [.addEventToLocalStore(.init(ekEvent: newEvent))]
                    promise(.success(actions))
                } catch {
                    let actions: [AppAction] = [
                        .setEventErrorMessage("An error occurred while saving a new event."),
                        .setShowError(true)
                    ]
                    promise(.success(actions))
                }
            }
        }
    }

    /// Update the given event and directly commit the updated event to the default EventStore.
    func updateEvent(with newEvent: Event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                guard
                    let identifier = newEvent.eventIdentifier,
                    let event = eventStore.event(withIdentifier: identifier)
                else {
                    promise(.success([.empty]))
                    return
                }
                event.update(with: newEvent)

                do {
                    try eventStore.save(event, span: .thisEvent, commit: true)
                    let actions: [AppAction] = [.updateEventInLocalStore(.init(ekEvent: event))]
                    promise(.success(actions))
                } catch {
                    let actions: [AppAction] = [
                        .setEventErrorMessage("An error occurred while updating an existing event."),
                        .setShowError(true)
                    ]
                    promise(.success(actions))
                }
            }
        }
    }

    /// Remove the given event and directly commit the change directly to the default EventStore.
    func removeEvent(_ event: Event) -> AnyPublisher<AppAction, Never> {
        makeActions {
            Future { promise in
                guard
                    let identifier = event.eventIdentifier,
                    let targetEvent = eventStore.event(withIdentifier: identifier)
                else {
                    promise(.success([.empty]))
                    return
                }

                do {
                    try eventStore.remove(targetEvent, span: .thisEvent, commit: true)
                    let actions: [AppAction] = [.removeEventFromLocalStore(.init(ekEvent: targetEvent))]
                    promise(.success(actions))
                } catch {
                    let actions: [AppAction] = [
                        .setEventErrorMessage("An error occurred while deleting an existing event."),
                        .setShowError(true)
                    ]
                    promise(.success(actions))
                }
            }
        }
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
