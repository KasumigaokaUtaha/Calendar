//
//  EventsListView.swift
//  RWCalendar
//
//  Created by Liu on 03.01.22.
//

import EventKit
import Foundation
import SwiftUI

struct EventLabel: View {
    @EnvironmentObject var customizationData: CustomizationData
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    let event: Event
    let dateFormatter: DateFormatter

    init(event: Event) {
        self.event = event
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
    }

    func isAllDay(_ event: Event) -> Bool {
        let calendar = Calendar.current
        let startTimeHour = calendar.component(.hour, from: event.startDate)
        let endTimeHour = calendar.component(.hour, from: event.endDate)
        let startTimeDay = calendar.component(.day, from: event.startDate)
        let endTimeDay = calendar.component(.day, from: event.endDate)
        _ = dateFormatter.string(from: store.state.selectedDate!)

        return startTimeHour <= 1 && endTimeHour >= 23 || startTimeDay < store.state.selectedDay && endTimeDay > store
            .state.selectedDay
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .bold()
                .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))

            Spacer()
            HStack {
                if isAllDay(self.event) {

                    Text(NSLocalizedString("All day", comment: "All day"))
                        .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))

                } else {
                    Text(
                        "\(dateFormatter.string(from: event.startDate)) - \(dateFormatter.string(from: event.endDate))"
                    )
                    .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct EventsListView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData
    @State private var showMiniEventList = false

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
                            EventLabel(event: event)
                                .background(
                                    Capsule()

                                        .strokeBorder(lineWidth: .infinity)
                                        .background(Color(cgColor: event.calendar.cgColor))
                                        .opacity(0.5)
                                )

                                .onTapGesture {
                                    store.send(.setSelectedEvent(event))
                                    showMiniEventList.toggle()
                                }
                        }
                    }
                    .sheet(isPresented: $showMiniEventList) {
                        EventDisplayView()
                    }

                } else {

                    Text(NSLocalizedString("No events", comment: "No events"))
                        .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                }
            } else {
                Text(NSLocalizedString("No events", comment: "No events"))
                    .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))

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
