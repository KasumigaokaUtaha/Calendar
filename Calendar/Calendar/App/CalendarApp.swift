//
//  CalendarApp.swift
//  Calendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

@main
struct CalendarApp: App {
    let store: AppStore<AppState, AppAction, AppEnvironment>

    init() {
        store = AppStore(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }

    func onStartTasks() {
        store.send(.loadYearData(date: store.state.currentDate, range: -5 ... 5))
    }
}
