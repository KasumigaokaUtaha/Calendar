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
        let calendar = state.calendar
        let startOfWeek = state.startOfWeek

        return environment.year.performCalculation(
            date: date,
            range: range,
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
    case let .setStartOfWeek(weekday):
        state.startOfWeek = weekday
//    case let .setCurrentEvent(event):
//        state.currentEvent = event
//    case let .insertNewEvent(event):
//        state.events.append(event)
    }

    return nil
}
