//
//  EventCreatingView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import SwiftUI

struct EventUpdateView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var dataController: DataController

    var event: Event

    @State var name: String
    @State var startDate: Date
    @State var endDate: Date

    init(_ event: Event) {
        self.event = event
        _name = State(initialValue: event.name ?? "Default Name")
        _startDate = State(initialValue: event.startDate ?? Date())
        _endDate = State(initialValue: event.endDate ?? Date())
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
                Text(name)
            }
            .navigationTitle("Event")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let new_Event = EventDTO(name: event.name!, startDate: event.startDate!, endDate: event.endDate!)
                        store.send(.updateEvent(newEvent: new_Event, id: event.id!))
                        // TODO: leave the view
                    }
                    .disabled(endDate < startDate)
                }
            }
        }
    }
}

struct EventUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        EventUpdateView(Event.example)
            .environmentObject(DataController.preview)
    }
}

//func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}
