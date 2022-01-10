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
    let customizationData: CustomizationData

    init() {
        store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        
        customizationData = CustomizationData()
    }

    var body: some Scene {
        WindowGroup {
            WrapperView()
                .environmentObject(customizationData)
                .environmentObject(store)
                //.environmentObject(customizationData)
                .onAppear(perform: onStartTasks)
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
