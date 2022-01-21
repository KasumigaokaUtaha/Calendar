//
//  Extensions.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 20.01.22.
//

import Foundation
import EventKit

extension Sequence where Element == String {
    func toData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Data {
    func toStringArray() -> [String]? {
        return (try? JSONSerialization.jsonObject(with: self, options: []) as? [String])
    }
}

extension EKEvent {
    convenience init(event: Event, eventStore: EKEventStore) {
        self.init(eventStore: eventStore)

        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.calendar = event.calendar
        self.notes = event.notes
        self.alarms = event.alarms
    }
}
