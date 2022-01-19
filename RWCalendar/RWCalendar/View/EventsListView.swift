//
//  EventsListView.swift
//  RWCalendar
//
//  Created by Liu on 03.01.22.
//

import Foundation
import SwiftUI

struct EventLabel: View {
    let event: Event
    let dateFormatter: DateFormatter

    init(event: Event) {
        self.event = event
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
    }

    var body: some View {
        HStack {
            Text(event.name)
            Spacer()
            Text(dateFormatter.string(from: event.dateStart))
        }
    }
}

struct EventsListView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var body: some View {
        ScrollView {
            if store.state.eventList.count == 0 {
                Text("No events")
            } else {
                List(store.state.eventList, id: \.name) {
                    event in EventLabel(event: event)
                }
            }
        }
    }
}
