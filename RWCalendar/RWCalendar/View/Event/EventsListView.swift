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
            Text(event.title)
            Spacer()
            Text(dateFormatter.string(from: event.startDate))
        }
    }
}

struct EventsListView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var eventIDs: [String]? {
        guard let selectedDate = store.state.selectedDate else {
            return nil
        }

        return store.state.dateToEventIDs[
            .init(date: selectedDate, calendar: store.state.calendar)
        ]
    }

    var body: some View {
        ScrollView {
            if let eventIDs = eventIDs {
                if eventIDs.count > 0 {
                    VStack {
                        ForEach(events(with: eventIDs), id: \.self) { event in
                            Text("\(event.title)")
                        }
                    }
                } else {
                    Text("No events")
                }
            } else {
                Text("No events")
            }
        }
    }

    func events(with eventIDs: [String]) -> [Event] {
        var events: [Event] = []

        for eventID in eventIDs {
            if let event = store.state.eventIDToEvent[eventID] {
                if store.state.recurringEventIDs.contains(eventID) {
                    guard
                        let selectedDate = store.state.selectedDate,
                        let recurrenceRule = event.recurrenceRule,
                        let nextRecurringEvent = Util.nextRecurringEvent(
                            for: event,
                            at: selectedDate,
                            with: recurrenceRule,
                            calendar: store.state.calendar
                        )
                    else {
                        continue
                    }

                    events.append(nextRecurringEvent)
                } else {
                    events.append(event)
                }
            }
        }

        return events
    }
}
