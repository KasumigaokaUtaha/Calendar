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
                        let new_Event = EventDTO(name: event.name, startDate: event.startDate, endDate: event.endDate)
                        store.send(.updateEvent(event: new_Event, id: id))
                        // TODO: leave the view
                    }
                    .disabled(endDate < startDate)
                }
            }
        }
    }
}

//struct EventUpdateView_Previews: PreviewProvider {
//    static let store = AppStore(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())
    
//    static var example: Event {
//
//        let context =
//
//        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
//        fetchRequest.fetchLimit = 1
//
//        let results = try? context.fetch(fetchRequest)
//
//        return (results?.first!)!
//    }
    
//    static var previews: some View {
//        EventUpdateView(nil)
//    }


//func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}
