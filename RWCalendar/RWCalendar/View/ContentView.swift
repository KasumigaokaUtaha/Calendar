//
//  ContentView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var body: some View {
        switch store.state.currentTab {
        case .year:
//            GeometryReader { proxy in
//                CompactCalendarYearView(size: proxy.size)
//            }
            ContainerView {
                CompactCalendarYearView()
            }
        case .month:
            ContainerView {
                // TODO: replace with actual view
                Text("Month")
                    .navigationTitle(String(format: "%d %d", store.state.selectedYear, store.state.selectedMonth))
            }
        case .week:
            ContainerView {
                // TODO: replace with actual view
                Text("Week")
            }
        case .day:
            ContainerView {
                // TODO: replace with actual view
                CalendarDayView()
                Text("day")
            }
        case .settings:
            ContainerView {
                // TODO: replace with actual view
                Text("settings")
            }
        case .onboarding:
            ContainerView {
                // TODO: replace with actual view
                Text("onboarding")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        ContentView()
            .environmentObject(store)
            .onAppear {
                let rangeStart = store.state.currentYear - 1970
                store.send(.setScrollToToday(withAnimation: false))
                store.send(.loadYearDataRange(
                    base: store.state.currentYear,
                    range: -rangeStart ... 3
                ))
            }
    }
}
