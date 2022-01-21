//
//  EventCreatingView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import SwiftUI

struct EventUpdateView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State var title: String
    @State var startDate: Date
    @State var endDate: Date
    @State var remindingTimeBefore: Double // TODO: 
    @State var description: String
    @State var showLocationSelectionView = false

    var event: Event
    var offsets: [Double] = [60, 300, 600]

    init(_ event: Event) {
        self.event = event
        _title = State(initialValue: event.title)
        _startDate = State(initialValue: event.startDate)
        _endDate = State(initialValue: event.endDate)
        _remindingTimeBefore = State(initialValue: event.remindingOffset ?? 0.0)
        _description = State(initialValue: event.notes ?? "")
    }

    var body: some View {
//        NavigationView {
            Form {
                Section {
                    TextField(
                        "Title",
                        text: $title
                    )
                    Button {
                        showLocationSelectionView = true
                    } label: {
                        HStack {
                            Text("Location")
                                .foregroundColor(Color.secondary)
                            Spacer()
                            Image(systemName: "map")
                        }
                    }
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
                    Picker("Remind before", selection: $remindingTimeBefore) {
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
            .sheet(isPresented: $showLocationSelectionView, onDismiss: nil) {
                // TODO: Location Selection View
                VStack {
                    Button("Done", action: { showLocationSelectionView = false })
                    Spacer()
                    Text("TODO")
                    Spacer()
                }
            }
//            .navigationTitle("Event")
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        let newEvent = Event(
//                            name: title, dateStart: startDate, dateEnd: endDate, description: description,
//                            remindingOffset: remindingTimeBefore
//                        )
//                        store.send(.saveEvent(newEvent: newEvent))
//                        // TODO: leave the view
//                    }
//                    .disabled(endDate < startDate)
//                }
//            }
//        }
    }
}
