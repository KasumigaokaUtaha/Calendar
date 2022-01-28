//
//  CompactCalendarDayView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/24.
//

import SwiftUI

struct CompactCalendarDayView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @State var currentWeek: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                DayToolbarView(currentWeek: $currentWeek)
                    .onAppear {
                        let d = Date()
                        let day = Calendar.current.component(.day, from: d)
                        let month = Calendar.current.component(.month, from: d)
                        let year = Calendar.current.component(.year, from: d)
                        store.send(.setSelectedDay(day))
                        store.send(.setSelectedMonth(month))
                        store.send(.setSelectedYear(year))
                    }
//                Spacer(minLength: 20)
                DayTaskTableView()
            }
        }
    }
}

struct CompactCalendarDayView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    
    static var previews: some View {
        CompactCalendarDayView()
            .environmentObject(store)
    }
}
