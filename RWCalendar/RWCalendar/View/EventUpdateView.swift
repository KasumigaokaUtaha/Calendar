//
//  EventCreatingView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import SwiftUI

struct EventUpdateView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var event: Event

    @State var name: String
    @State var startDate: Date
    @State var endDate: Date
    @State var remindingTimeBefore: Double
    @State var description: String

    var offsets: [Double] = [60, 300, 600]

    init(_ event: Event) {
        self.event = event
        _name = State(initialValue: event.name)
        _startDate = State(initialValue: event.dateStart)
        _endDate = State(initialValue: event.dateEnd)
        _remindingTimeBefore = State(initialValue: event.remindingOffset)
        _description = State(initialValue: event.description)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(
                        "name",
                        text: $name
                    )
                }
                Section {
                    DatePicker(
                        "Start",
                        selection: $startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    DatePicker(
                        "End",
                        selection: $endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    Picker("remind before", selection: $remindingTimeBefore) {
                        ForEach(offsets, id: \.self) {
                            Text("\($0 / 60) minutes")
                        }
                    }
                }
                Section {
                    TextField("Description", text: $description)
                }
                Section {
                    Button("Delete", action: {})
                        .foregroundColor(Color.red)
                }
            }
            .navigationTitle("Event")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newEvent = Event(
                            name: name, dateStart: startDate, dateEnd: endDate, description: description,
                            remindingOffset: remindingTimeBefore
                        )
                        store.send(.saveEvent(newEvent: newEvent))
                        // TODO: leave the view
                    }
                    .disabled(endDate < startDate)
                }
            }
        }
    }
}
