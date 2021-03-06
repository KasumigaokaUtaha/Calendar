//
//  Extensions.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 20.01.22.
//

import EventKit
import Foundation

extension Sequence where Element == String {
    func toData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Date {
    func getMonthDate() -> [Date] {
        let monthDate = Calendar.current.range(of: .day, in: .month, for: self)!

        let component = Calendar.current.dateComponents([.year, .month], from: self)

        let starter = Calendar.current.date(from: component) ?? Date()

        return monthDate.compactMap { day -> Date in
            Calendar.current.date(byAdding: .day, value: day - 1, to: starter)!
        }
    }
}

extension Data {
    func toStringArray() -> [String]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String]
    }
}

extension Calendar {
    func numberOfDaysBetween(from start: Date, to end: Date) -> Int {
        let startDate = startOfDay(for: start)
        let endDate = startOfDay(for: end)
        let numberOfDays = dateComponents([.day], from: startDate, to: endDate)

        return numberOfDays.day!
    }
}

extension EKEvent {
    convenience init(event: Event, eventStore: EKEventStore) {
        self.init(eventStore: eventStore)

        title = event.title
        startDate = event.startDate
        endDate = event.endDate
        calendar = event.calendar
        url = event.url != nil ? URL(string: event.url!) : nil
        notes = event.notes
        alarms = event.alarms
        if let recurrenceRule = event.recurrenceRule {
            recurrenceRules = [recurrenceRule]
        }
    }

    func update(with event: Event) {
        title = event.title
        startDate = event.startDate
        endDate = event.endDate
        calendar = event.calendar
        url = event.url != nil ? URL(string: event.url!) : nil
        notes = event.notes
        alarms = event.alarms
        if let recurrenceRule = event.recurrenceRule {
            recurrenceRules = [recurrenceRule]
        } else {
            recurrenceRules = nil
        }
    }
}
