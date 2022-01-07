//
//  EventsListView.swift
//  RWCalendar
//
//  Created by Liu on 03.01.22.
//

import SwiftUI
import Foundation

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
            Text(event.name ?? "default name")
            Spacer()
            Text(dateFormatter.string(from: event.startDate!))
        }
    }
}

struct EventsListView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    
    @FetchRequest(entity: Event.entity(), sortDescriptors: []) var events: FetchedResults<Event>

    var body: some View {
        ScrollView {
            if (events.count == 0) {
                Text("No events")
            } else {
                List(events, id:\.name) {
                    event in EventLabel(event: event)
                }
            }
        }
        
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        EventsListView()
            .environmentObject(store)
//            .environmentObject(DataController.preview)
    }
}
