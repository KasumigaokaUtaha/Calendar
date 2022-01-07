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
    
    @StateObject private var dataController = DataController()

    init() {
        store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onAppear(perform: onStartTasks)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }

    func onStartTasks() {
        store.send(.loadYearData(
            date: store.state.currentDate,
            range: -5 ... 5
        ))
    }
}
