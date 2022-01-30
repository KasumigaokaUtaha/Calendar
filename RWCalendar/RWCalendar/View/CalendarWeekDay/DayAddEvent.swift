//
//  DayAddEvent.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/24.
//

import EventKit
import SwiftUI

struct DayAddEvent: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State private var showingDayEventSheet = false
    // to show the adding view
    var body: some View {
        Button {
            showingDayEventSheet.toggle()
        }
            label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: self.$showingDayEventSheet) {
                EventEditView(nil, defaultEventCalendar: store.state.defaultEventCalendar)
                // Fallback on earlier versions
            }
    }
}

struct DayAddEvent_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        DayAddEvent()
            .environmentObject(store)
    }
}
