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
    @Environment(\.presentationMode) var presentationMode

    @State var title: String
    // TODO: var location
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var calendar: EKCalendar
    @State private var reminderTime: ReminderTime?
    @State private var url: String
    @State private var notes: String
    @State private var recurr: EKRecurrenceFrequency?

    @State private var showLocationSelectionView = false

    @State private var showActionSheetForCancel = false
    @State private var showConfirmationForDelete = false

    private let event: Event?
    private let navigationTitle: String

    init(_ event: Event?, defaultEventCalendar: EKCalendar) {
        if let event = event {
            self.event = event
            navigationTitle = NSLocalizedString("event_edit", comment: "Edit Event")
        } else {
            self.event = nil
            navigationTitle = NSLocalizedString("event_add", comment: "Add Event")
        }

        _title = State(initialValue: event?.title ?? "")
        _startDate = State(initialValue: event?.startDate ?? Date())
        _endDate = State(initialValue: event?.endDate ?? Date())
        _calendar = State(initialValue: event?.calendar ?? defaultEventCalendar)
        _reminderTime = State(initialValue: event?.reminderTime)
        _url = State(initialValue: event?.url ?? "")
        _notes = State(initialValue: event?.notes ?? "")
        _recurr = State(initialValue: event?.recurrenceRule?.frequency)
    }

    init(_ event: Event?, defaultEventCalendar: EKCalendar, date: Date?) {
        if let event = event {
            self.event = event
            navigationTitle = NSLocalizedString("event_edit", comment: "Edit Event")
        } else {
            self.event = nil
            navigationTitle = NSLocalizedString("event_add", comment: "Add Event")
        }

        _startDate = State(initialValue: date ?? Date())
        _endDate = State(initialValue: date ?? Date())
        _title = State(initialValue: event?.title ?? "")
        _calendar = State(initialValue: event?.calendar ?? defaultEventCalendar)
        _reminderTime = State(initialValue: event?.reminderTime)
        _url = State(initialValue: event?.url ?? "")
        _notes = State(initialValue: event?.notes ?? "")
        _recurr = State(initialValue: event?.recurrenceRule?.frequency)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(
                        NSLocalizedString("title", comment: "Title"),
                        text: $title
                    )
                    Button {
                        showLocationSelectionView = true
                    } label: {
                        HStack {
                            Text(NSLocalizedString("location", comment:"Location"))
                                .foregroundColor(Color.secondary)
                            Spacer()
                            Image(systemName: "map")
                        }
                    }
                }
                Section {
                    DatePicker(
                        NSLocalizedString("startDate", comment: "Start Date"),
                        selection: $startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    DatePicker(
                        NSLocalizedString("endDate", comment: "End"),
                        selection: $endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    Picker(NSLocalizedString("remind", comment: "Remind"), selection: $reminderTime) {
                        Text(NSLocalizedString("none", comment: "None"))
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
                    TextField(NSLocalizedString("url", comment: "URL"), text: $url)
                        .keyboardType(.URL)
                    TextEditor(text: $notes)
                }
                if event != nil {
                    Section {
                        Button {
                            showConfirmationForDelete.toggle()
                        } label: {
                            Text(NSLocalizedString("delete", comment: "Delete"))
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .actionSheet(isPresented: $showConfirmationForDelete) {
                            ActionSheet(
                                title: Text(NSLocalizedString("deleteEventMessage", comment: "Delete this event")),
                                message: Text(NSLocalizedString("removeEventMessage", comment: "This event will be remove")),
                                buttons: [
                                    .cancel(),
                                    .destructive(
                                        Text(NSLocalizedString("delete", comment: "Delete")),
                                        action: {
                                            store.send(.removeEvent(event!))
                                            store.send(.setSelectedEvent(nil))
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    ),
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
            .navigationTitle(navigationTitle)
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
                        values: store.state.sourceAndCalendars[source]!
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
                Text(NSLocalizedString("event_Calendar", comment: "Calendar"))
                Spacer()
                Text("\(calendar.title)")
                    .foregroundColor(Color.secondary)
            }
        }
    }

    func makeEventRecurrencePicker() -> some View {
        Picker("Recurrence Rule", selection: $recurr) {
            Text("Never").tag(EKRecurrenceFrequency?.none)
            Text("Daily").tag(EKRecurrenceFrequency?.some(.daily))
            Text("Weekly").tag(EKRecurrenceFrequency?.some(.weekly))
            Text("Monthly").tag(EKRecurrenceFrequency?.some(.monthly))
            Text("Yearly").tag(EKRecurrenceFrequency?.some(.yearly))
        }
        
    }

    func makeToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("cancel", comment: "Cancel")) {
                    showActionSheetForCancel = true
                }
                .actionSheet(isPresented: $showActionSheetForCancel) {
                    ActionSheet(
                        title: Text(NSLocalizedString("cancelChangesMessage", comment: "Cancel your changes on this event")),
                        message: Text(NSLocalizedString("abortChangesMessage", comment: "Your changes will be aborted")),
                        buttons: [
                            .cancel(),
                            .destructive(
                                Text(NSLocalizedString("abortChanges", comment: "Abort changes")),
                                action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            ),
                        ]
                    )
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(event != nil ? NSLocalizedString("save", comment: "Save") : NSLocalizedString("add", comment: "Add")) {
                    let newEvent = Event(
                        title: title,
                        startDate: startDate,
                        endDate: endDate,
                        calendar: event?.calendar ?? calendar,
                        url: url,
                        notes: notes,
                        reminderTime: reminderTime,
                        eventIdentifier: event?.eventIdentifier,
                        recurrenceRule: recurr != nil ? EKRecurrenceRule(recurrenceWith: recurr!, interval: 1, end: nil) : nil
                    )

                    if event != nil {
                        store.send(.updateEvent(with: newEvent))
                        store.send(.setSelectedEvent(newEvent))
                    } else {
                        store.send(.addEvent(newEvent))
                        store.send(.setSelectedEvent(newEvent))
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
                .disabled(endDate < startDate)
            }
        }
    }
}
