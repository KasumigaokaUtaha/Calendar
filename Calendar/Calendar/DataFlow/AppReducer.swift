//
//  AppReducer.swift
//  Calendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment _: AppEnvironment
) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case let .loadYearData(date, range):
        // TODO:
        break
    case let .setCurrentDate(date):
        state.currentState = date
    }

    return nil
}
