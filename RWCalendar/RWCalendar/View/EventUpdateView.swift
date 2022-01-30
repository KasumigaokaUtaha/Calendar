//
//  EventCreatingView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import SwiftUI

struct EventUpdateView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var event: EventDTO
    var id: UUID

    @State var name: String
    @State var startDate: Date
    @State var endDate: Date

    init(_ event: EventDTO, _ id: UUID) {
        self.event = event
        self.id = id
        _name = State(initialValue: event.name)
        _startDate = State(initialValue: event.startDate)
        _endDate = State(initialValue: event.endDate)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField(
                    "name",
                    text: $name
                )
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
            }
            .navigationTitle("Event")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newEvent = EventDTO(name: event.name, startDate: event.startDate, endDate: event.endDate)
                        store.send(.updateEvent(event: newEvent, id: id))
                        // TODO: leave the view
                    }
                    .disabled(endDate < startDate)
                }
            }
        }
    }
}
