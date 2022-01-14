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
    
//    @StateObject private var dataController = DataController()

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
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }

    func onStartTasks() {
        let rangeStart = store.state.currentYear - 1970
        store.send(.setScrollToToday(withAnimation: false))
        store.send(.loadYearDataRange(
            base: store.state.currentYear,
            range: -rangeStart ... 3
        ))
    }
}
