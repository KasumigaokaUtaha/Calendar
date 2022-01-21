//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import Foundation
import EventKit

struct Event {
    var title: String
    var startDate: Date
    var endDate: Date
    var calendar: EKCalendar
    var notes: String?
    var remindingOffset: Double?
    var alarms: [EKAlarm]?
    
    init(title: String, startDate: Date, endDate: Date, calendar: EKCalendar, notes: String?, remindingOffset: Double?, alarms: [EKAlarm]?) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.notes = notes
        self.remindingOffset = remindingOffset
        self.alarms = alarms
    }
    
    init(ekEvent: EKEvent) {
        self.title = ekEvent.title
        self.startDate = ekEvent.startDate
        self.endDate = ekEvent.endDate
        self.calendar = ekEvent.calendar
        self.notes = ekEvent.notes
        self.remindingOffset = nil
        self.alarms = ekEvent.alarms
    }
}
