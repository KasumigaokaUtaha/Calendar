//
//  EventEditView.swift
//  RWCalendar
//
//  Created by Liu on 01.01.22.
//

import EventKit
import SwiftUI

/// A view for creating, editing, and deleting calendar events.
struct EventEditView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State var title: String
    // TODO: var location
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var calendar: EKCalendar
    @State private var reminderTime: ReminderTime?
    @State private var url: String
    @State private var notes: String

    @State private var showLocationSelectionView = false

    private let event: Event?
    private let navigationTitle: String

    init(_ event: Event?, defaultEventCalendar: EKCalendar) {
        if let event = event {
            self.event = event
            navigationTitle = "Edit Event"
        } else {
            self.event = nil
            navigationTitle = "Add Event"
        }

        _title = State(initialValue: event?.title ?? "")
        _startDate = State(initialValue: event?.startDate ?? Date())
        _endDate = State(initialValue: event?.endDate ?? Date())
        _calendar = State(initialValue: event?.calendar ?? defaultEventCalendar)
        _reminderTime = State(initialValue: event?.reminderTime)
        _url = State(initialValue: event?.url ?? "")
        _notes = State(initialValue: event?.notes ?? "")
    }

    var body: some View {
        NavigationView {
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
                    Picker("Remind", selection: $reminderTime) {
                        Text("None")
                            .tag(ReminderTime?.none)
                        ForEach(ReminderTime.allCases) { time in
                            Text(time.description)
                                .tag(ReminderTime?.some(time))
                        }
                    }
                }
                Section {
                    makeCalendarPicker()
                }
                Section {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                    TextEditor(text: $notes)
                }
                if event != nil {
                    Section {
                        Button {
                            // TODO: present an action sheet to confirm this action
                            store.send(.removeEvent(event!))
                        } label: {
                            Text("Delete")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
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
            .toolbar {
                makeToolbar()
            }
            .navigationTitle("Update Event")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    func makeCalendarPicker() -> some View {
        NavigationLink {
            MultiplePickerView(
                selection: $calendar,
                pickerModels: store.state.allSources.map { source -> PickerModel<EKCalendar> in
                    PickerModel(
                        values: store.state.sourceToCalendars[source]!
                            .reduce([String: EKCalendar]()) { result, calendar in
                                var result = result
                                result.updateValue(calendar, forKey: calendar.title)
                                return result
                            },
                        headerTitle: source.title
                    )
                }
            )
        } label: {
            HStack {
                Text("Calendar")
                Spacer()
                Text("\(calendar.title)")
                    .foregroundColor(Color.secondary)
            }
        }
    }

    func makeToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    // TODO: Present action sheet to confirm this action before dismissing this view
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(event != nil ? "Save" : "Add") {
                    let newEvent = Event(
                        title: title,
                        startDate: startDate,
                        endDate: endDate,
                        calendar: event?.calendar ?? calendar,
                        url: url,
                        notes: notes,
                        reminderTime: reminderTime,
                        eventIdentifier: event?.eventIdentifier
                    )

                    if event != nil {
                        store.send(.updateEvent(with: newEvent))
                    } else {
                        store.send(.addEvent(newEvent))
                    }
                    // TODO: Dismiss this view
                }
                .disabled(endDate < startDate)
            }
        }
    }
}
