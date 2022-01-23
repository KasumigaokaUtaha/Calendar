//
//  AppReducer.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import UIKit

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

// swiftlint:disable cyclomatic_complexity
/// The app-wide redux reducer implementation
func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: AppEnvironment
) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case .empty:
        return nil
    case let .loadYearDataIfNeeded(base):
        guard let baseIndex = state.allYears.firstIndex(of: base) else {
            return nil
        }
        guard !state.isLoadingYearData else {
            // Try it later
            return Just(AppAction.loadYearDataIfNeeded(base: base))
                .delay(for: .seconds(0.5), tolerance: nil, scheduler: DispatchQueue.main, options: nil)
                .eraseToAnyPublisher()
        }

        if baseIndex == state.allYears.endIndex - 1 {
            return Just((base, 1, .future))
                .map { base, count, direction in
                    AppAction.loadYearData(base: base, count: count, direction: direction)
                }
                .eraseToAnyPublisher()
        }
    case let .loadYearData(base, count, direction):
        guard !state.isLoadingYearData else {
            return nil
        }

        var range: ClosedRange<Int>
        switch direction {
        case .past:
            range = -count ... -1
        case .future:
            range = 1 ... count
        }

        return Just((base, range))
            .map { base, range in
                AppAction.loadYearDataRange(base: base, range: range)
            }
            .eraseToAnyPublisher()
    case let .loadYearDataRange(base, range):
        guard !state.isLoadingYearData else {
            return nil
        }

        var alternativeRange: ClosedRange<Int>?
        for offset in range {
            if state.years[base + offset] != nil {
                guard range.lowerBound <= offset - 1 else {
                    return nil
                }
                alternativeRange = ClosedRange(uncheckedBounds: (range.lowerBound, offset - 1))
            }
        }

        state.isLoadingYearData = true
        let calendar = state.calendar
        let startOfWeek = state.startOfWeek

        return environment.year.performCalculation(
            currentYear: base,
            range: alternativeRange == nil ? range : alternativeRange!,
            startOfWeek: startOfWeek,
            calendar: calendar
        )
        .subscribe(on: environment.backgroundQueue)
        .map { allYears in
            AppAction.setYearDataCollection(allYears)
        }
        .eraseToAnyPublisher()
    case let .setYearData(yearData):
        state.allYears.append(yearData.year)
        state.years.updateValue(
            yearData,
            forKey: yearData.year
        )
        state.allYears.sort(by: <)
    case let .setYearDataCollection(allYears):
        state.isLoadingYearData = false
        for yearData in allYears {
            state.allYears.append(yearData.year)
            state.years.updateValue(
                yearData,
                forKey: yearData.year
            )
        }
        state.allYears.sort(by: <)
    case let .setCurrentDate(date):
        state.currentDate = date
        state.currentYear = state.calendar.component(.year, from: date)
    case let .setStartOfWeek(weekday):
        state.startOfWeek = weekday
    case let .setScrollToToday(withAnimation):
        state.scrollToToday = true
        state.isScrollToTodayAnimated = withAnimation
    case .resetScrollToToDay:
        state.scrollToToday = false
    case let .setShowAlert(showAlert):
        state.showAlert = showAlert
    case let .setAlertTitle(title):
        state.alertTitle = title
    case let .setAlertMessage(message):
        state.alertMessage = message
    case let .setShowError(show):
        state.showError = show
    case let .setEventErrorMessage(errorMessage):
        state.errorMessage = errorMessage
        state.showError = errorMessage != ""
    case let .open(tab):
        // TODO: adapt state according to the new tab if necessary
        state.currentTab = tab
    case let .setSelectedYear(year):
        state.selectedYear = year
    case let .setSelectedMonth(month):
        state.selectedMonth = month
    case let .setSelectedEvent(event):
        state.selectedEvent = event
    case let .addEvent(newEvent):
        return environment.event.addEvent(newEvent)
    case let .updateEvent(newEvent):
        return environment.event.updateEvent(with: newEvent)
    case let .removeEvent(event):
        return environment.event.removeEvent(event)
    case let .addEventToLocalStore(event), let .removeEventFromLocalStore(event):
        guard
            event.endDate >= event.startDate,
            let eventIdentifier = event.eventIdentifier,
            let startDate = state.calendar
                .date(from: state.calendar.dateComponents([.year, .month, .day], from: event.startDate))
        else {
            return nil
        }

        let dateCount = state.calendar.component(.day, from: event.endDate) - state.calendar
            .component(.day, from: event.startDate)
        let dates = (0 ... dateCount)
            .compactMap { offset in state.calendar.date(byAdding: .day, value: offset, to: startDate) }
        let keys: [RWDate] = dates.map { .init(date: $0, calendar: state.calendar) }
        
        switch action {
        case .addEventToLocalStore(_):
            for key in keys {
                if !state.dateToEventIDs.keys.contains(key) {
                    state.dateToEventIDs[key] = []
                }

                var values = state.dateToEventIDs[key]!
                values.append(eventIdentifier)
                state.dateToEventIDs.updateValue(values, forKey: key)
            }

            if !state.eventIDToEvent.keys.contains(eventIdentifier) {
                state.eventIDToEvent.updateValue(event, forKey: eventIdentifier)
            } else {
                // Log non unique event identifier
            }

            if !state.allEventIDs.contains(eventIdentifier) {
                state.allEventIDs.append(eventIdentifier)
            } else {
                // Log non unique event identifier
            }

            if event.hasRecurrenceRule, !state.recurringEventIDs.contains(eventIdentifier) {
                state.recurringEventIDs.append(eventIdentifier)
            }
        case .removeEventFromLocalStore(_):
            for key in keys {
                guard
                    state.dateToEventIDs.keys.contains(key),
                    let index = state.dateToEventIDs[key]!.firstIndex(of: eventIdentifier)
                else {
                    continue
                }
                
                var values = state.dateToEventIDs[key]!
                values.remove(at: index)
                state.dateToEventIDs.updateValue(values, forKey: key)
            }
            
            state.eventIDToEvent.removeValue(forKey: eventIdentifier)
            if let index = state.allEventIDs.firstIndex(of: eventIdentifier) {
                state.allEventIDs.remove(at: index)
            }
            if event.hasRecurrenceRule, let index = state.recurringEventIDs.firstIndex(of: eventIdentifier) {
                state.recurringEventIDs.remove(at: index)
            }
        default:
            fatalError()
        }
    case let .updateEvenInLocalStore(event):
        return [
            AppAction.removeEventFromLocalStore(event),
            AppAction.addEventToLocalStore(event)
        ]
        .publisher
        .flatMap { action in Just(action) }
        .eraseToAnyPublisher()
    case .loadAppStorageProperties:
        state.activatedCalendars = state.storedActivatedCalendars.toStringArray() ?? []
    case let .setActivatedCalendars(names):
        state.activatedCalendars = names
        if let data = names.toData() {
            state.storedActivatedCalendars = data
        }
    case let .activateCalendar(name):
        guard !state.activatedCalendars.contains(name) else {
            return nil
        }

        let allActivatedCalendars = state.activatedCalendars + [name]
        return Just(AppAction.setActivatedCalendars(allActivatedCalendars))
            .eraseToAnyPublisher()
    case let .deactivateCalendar(name):
        guard let index = state.activatedCalendars.firstIndex(of: name) else {
            return nil
        }

        var allActivatedCalendars = state.activatedCalendars
        allActivatedCalendars.remove(at: index)
        return Just(AppAction.setActivatedCalendars(allActivatedCalendars))
            .eraseToAnyPublisher()
    case let .loadDefaultCalendar(entityType):
        return environment.event.getDefaultCalendar(for: entityType)
    case let .setDefaultCalendar(calendar, entityType):
        switch entityType {
        case .event:
            state.defaultEventCalendar = calendar
        case .reminder:
            state.defaultReminderCalendar = calendar
        @unknown default:
            fatalError()
        }
    case let .requestAccess(entityType):
        return environment.event.requestAccess(to: entityType)
    }
    return nil
}
