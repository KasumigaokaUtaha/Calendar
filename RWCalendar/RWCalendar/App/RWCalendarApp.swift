//
//  CalendarApp.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

@main
struct RWCalendarApp: App {
    let store: AppStore<AppState, AppAction, AppEnvironment>

    init() {
        store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
    }

    var body: some Scene {
        WindowGroup {
            YearView(year: 2022, monthColumnCount: 2)
                .environmentObject(store)
                .onAppear(perform: onStartTasks)
        }
    }

    func onStartTasks() {
        store.send(.loadYearData(
            date: store.state.currentDate,
            range: -5 ... 5
        ))
    }
}
