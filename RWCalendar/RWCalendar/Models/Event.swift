//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import EventKit
import Foundation

struct Event: Hashable {
    var title: String
    var startDate: Date
    var endDate: Date
    var calendar: EKCalendar
    var url: String?
    var notes: String?
    var alarms: [EKAlarm]?
    var eventIdentifier: String?
    var recurrenceRule: EKRecurrenceRule?

    var hasRecurrenceRule: Bool {
        recurrenceRule != nil
    }

    var reminderTime: ReminderTime? {
        get {
            guard
                let alarms = alarms,
                let alarm = alarms.first
            else {
                return nil
            }

            return .init(rawValue: alarm.relativeOffset)
        }
        set {
            if let time = newValue {
                alarms = [.init(relativeOffset: time.rawValue)]
            } else {
                alarms = nil
            }
        }
    }

    init(
        title: String,
        startDate: Date,
        endDate: Date,
        calendar: EKCalendar,
        url: String?,
        notes: String?,
        reminderTime: ReminderTime?,
        eventIdentifier: String?,
        recurrenceRule: EKRecurrenceRule?
    ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.url = url
        self.notes = notes
        self.eventIdentifier = eventIdentifier
        self.recurrenceRule = recurrenceRule

        if let time = reminderTime {
            alarms = [.init(relativeOffset: time.rawValue)]
        } else {
            alarms = nil
        }
    }

    init(ekEvent: EKEvent) {
        title = ekEvent.title
        startDate = ekEvent.startDate
        endDate = ekEvent.endDate
        calendar = ekEvent.calendar
        url = ekEvent.url?.absoluteString
        notes = ekEvent.notes
        alarms = ekEvent.alarms
        eventIdentifier = ekEvent.eventIdentifier

        if let recurrenceRules = ekEvent.recurrenceRules, recurrenceRules.count > 0 {
            recurrenceRule = recurrenceRules[0]
        }
    }
}

enum ReminderTime: TimeInterval, CaseIterable, Identifiable {
    case zeroMinute = 0
    case oneMinute = 60
    case twoMinutes = 120
    case fiveMinutes = 300
    case tenMinutes = 600
    case fiveteenMinutes = 900
    case thirtyMinutes = 1800
    case oneHour = 3600

    var id: TimeInterval {
        rawValue
    }

    var description: String {
        var text: String

        switch self {
        case .zeroMinute:
            text = NSLocalizedString("zeroMinute", comment: "At time of event")
        case .oneMinute:
            text = NSLocalizedString("oneMinute", comment: "1 minute before")
        case .twoMinutes:
            text = NSLocalizedString("twoMinute", comment: "2 minutes before")
        case .fiveMinutes:
            text = NSLocalizedString("fiveMinute", comment: "5 minutes before")
        case .tenMinutes:
            text = NSLocalizedString("tenMinute", comment: "10 minutes before")
        case .fiveteenMinutes:
            text = NSLocalizedString("fifteenMinute", comment: "15 minutes before")
        case .thirtyMinutes:
            text = NSLocalizedString("thirtyMinute", comment: "30 minutes before")
        case .oneHour:
            text = NSLocalizedString("oneHour", comment: "1 hour before")
        }

        return text
    }
}
