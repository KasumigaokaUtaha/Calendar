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

    @State private var showActionSheetForCancel = false
    @State private var showConfirmationForDelete = false

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
                    // TODO: Add picker to select calendar
                    // Picker("Calendar", selection: $)
                }
                Section {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                    TextEditor(text: $notes)
                }
                if event != nil {
                    Section {
                        Button {} label: {
                            Text("Delete")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .actionSheet(isPresented: $showConfirmationForDelete) {
                            ActionSheet(
                                title: Text("Delete this event"),
                                message: Text("This event will be remove"),
                                buttons: [
                                    .cancel(),
                                    .destructive(
                                        Text("Delete"),
                                        action: {
                                            store.send(.removeEvent(event!))
                                        }
                                    )
                                ]
                            )
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

    func makeToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    showActionSheetForCancel = true
                }
                .actionSheet(isPresented: $showActionSheetForCancel) {
                    ActionSheet(
                        title: Text("Cancel your changes on this event"),
                        message: Text("Your changes will be aborted"),
                        buttons: [
                            .cancel(),
                            .destructive(
                                Text("Abort changes"),
                                action: {
                                    // TODO: leave the view
                                }
                            )
                        ]
                    )
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
                        eventIdentifier: event?.eventIdentifier,
                        recurrenceRule: event?.recurrenceRule
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
