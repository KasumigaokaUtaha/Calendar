//
//  CalendarDayView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct CalendarDayView: View {
    var body: some View {
        DayToolbarView()
    }
}

struct CalendarDayView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        CalendarDayView()
            .environmentObject(store)
    }
}
