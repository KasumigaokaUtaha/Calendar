//
//  AppReducer.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import UIKit

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: AppEnvironment
) -> AnyPublisher<AppAction, Never>? {
    switch action {
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
    case let .setCurrentEvent(event):
        if event != nil {
            state.currentEvent = event
        } else {
            state.showError = true
        }
    case let .updateEvent(newEvent, id):
        return environment.eventController.updateEvent(event: newEvent, id: id)
            .catch { _ -> Just<Event?> in Just(nil) }
            .subscribe(on: environment.backgroundQueue)
            .map { updatedEvent in
                AppAction.setCurrentEvent(updatedEvent)
            }
            .eraseToAnyPublisher()
    case let .setEventList(eventList):
        state.eventList = eventList
    case .loadAllEvents:

        return environment.eventController.getAllEvents()
            .subscribe(on: environment.backgroundQueue)
            .map { allEvents in
                AppAction.setEventList(eventList: allEvents)
            }
            .eraseToAnyPublisher()
    case let .setScrollToToday(withAnimation):
        state.scrollToToday = true
        state.isScrollToTodayAnimated = withAnimation
    case .resetScrollToDay:
        state.scrollToToday = false
//    case .loadExampleEvent:
//        state.currentEvent = environment.eventController.loadExampleEvent()
    }
    return nil
}
