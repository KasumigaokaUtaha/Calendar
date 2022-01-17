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
            GeometryReader { proxy in
                CompactCalendarYearView(size: proxy.size)
            }
        case .month:
            ContainerView {
            // TODO: replace with actual view
                Text("Month")
            }
        case .week:
            ContainerView {
            // TODO: replace with actual view
                Text("Week")
            }
        case .day:
            ContainerView {
            // TODO: replace with actual view
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
    static var previews: some View {
        ContentView()
    }
}
