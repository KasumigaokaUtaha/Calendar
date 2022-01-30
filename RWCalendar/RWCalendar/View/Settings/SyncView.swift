//
//  SyncView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/14.
//

/// For the reference for creating events and synchronize with iCloud

import EventKit
import SwiftUI

struct SyncView: View {
    @EnvironmentObject var customizationData: CustomizationData

    var eventStore: EKEventStore
    @State private var remoteSource: EKSource
    @State private var remoteCalendar: EKCalendar

    @State private var eventName = ""
    @State private var startDate = Date()
    @State private var endDate = Date() + 60

    @State private var disable = false

    init() {
        var addRWCalendar = true

        eventStore = EKEventStore()

        // Request access to events.
        eventStore.requestAccess(to: .event) { granted, error in
            if granted, error == nil {
                print("Grant access for Event succeeded!")
            } else {
                print("Grant access for Event failed!")
            }
        }
        // Request access to reminders.
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted, error == nil {
                print("Grant access for Reminder succeeded!")
            } else {
                print("Grant access for Reminder failed!")
            }
        }

        _remoteSource = State(initialValue: EKSource())
        _remoteCalendar = State(initialValue: EKCalendar(for: EKEntityType.event, eventStore: eventStore))

        for source in eventStore.sources {
            if source.sourceType == EKSourceType.calDAV, source.title == "iCloud" {
                _remoteSource = State(initialValue: source)
                break
            }
        }

        for calendar in eventStore.calendars(for: EKEntityType.event) {
            if calendar.type == EKCalendarType.calDAV, calendar.title == "RWCalendar" {
                _remoteCalendar = State(initialValue: calendar)
                addRWCalendar = false
                break
            }
        }

        if addRWCalendar {
            let calendar = EKCalendar(for: EKEntityType.event, eventStore: eventStore)
            calendar.source = remoteSource
            calendar.title = "RWCalendar"
            calendar.cgColor = CGColor(red: 89, green: 195, blue: 249, alpha: 0.5)
            do {
                try eventStore.saveCalendar(calendar, commit: true)
            } catch {
                print("Create RWCalendar failed")
            }
        }

        _disable = State(initialValue: eventName == "" || startDate >= endDate)
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Calendar Source")
                    Spacer()
                    Text(remoteSource.title)
                        .foregroundColor(.gray)
                }

                Picker(selection: $remoteCalendar, label: Text("Calendar Name"), content: {
                    ForEach(0 ..< eventStore.calendars(for: EKEntityType.event).count, id: \.self) { idx in
                        if eventStore.calendars(for: EKEntityType.event)[idx].source == remoteSource {
                            Text(eventStore.calendars(for: EKEntityType.event)[idx].title)
                                .tag(eventStore.calendars(for: EKEntityType.event)[idx])
                        }
                    }
                })

                HStack {
                    Text("Event Name")
                    Spacer()
                    TextField("Event Name", text: $eventName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 150)
                        .onChange(of: eventName) { _ in
                            disable = eventName == "" || startDate >= endDate
                        }
                }

                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    .onChange(of: startDate) { _ in
                        disable = eventName == "" || startDate >= endDate
                    }
                DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    .onChange(of: endDate) { _ in
                        disable = eventName == "" || startDate >= endDate
                    }
            }

            Section {
                HStack {
                    Spacer()
                    Button("Add Event") {
                        let event = EKEvent(eventStore: eventStore)
                        event.calendar = remoteCalendar
                        event.title = eventName
                        event.startDate = startDate
                        event.endDate = endDate
                        do {
                            try eventStore.save(event, span: EKSpan.thisEvent)
                        } catch {
                            print("Add event failed")
                        }
                    }
                    .disabled(disable == true)

                    Spacer()
                }
            }
        }
    }
}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        SyncView()
    }
}
