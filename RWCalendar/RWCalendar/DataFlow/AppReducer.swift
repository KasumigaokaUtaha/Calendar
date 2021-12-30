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
        let year = calendar.component(.year, from: date)

        for month in 1 ... 12 {
            // create MonthData
            // create DayData for the given month
        }
    case let .setCurrentDate(date):
        state.currentDate = date
    }

    return nil
}
