//
//  EventCreatingView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import SwiftUI

struct EventCreatingView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var dataController: DataController
    
    @State var event: Event

//    @State var name: String
//    @State var startDate: Date
//    @State var endDate: Date

    init(event: Event) {
        _event = State(initialValue: event)
//        _name = State(initialValue: event.name ?? "default name")
//        _startDate = State(initialValue: event.startDate ?? Date())
//        _endDate = State(initialValue: event.endDate ?? Date())
    }

    var body: some View {
        NavigationView {
            Form {
                TextField(
                    "name",
                    text: $event.name ?? "Default name"
                )
                DatePicker(
                    "Start",
                    selection: $event.startDate ?? Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                DatePicker(
                    "End",
                    selection: $event.endDate ?? Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            .navigationTitle("Event")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
//                        store.send(.insertNewEvent(newEvent))
                        dataController.saveEvent(named: event.name!, startFrom: event.startDate!, endAt: event.endDate!)
                        // TODO: leave the view
                    }
                }
            }
            .disabled(event.endDate! < event.startDate!)
        }
    }
}

struct EventCreatingView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        EventCreatingView(event: Event.example)
            .environmentObject(DataController.preview)
    }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
