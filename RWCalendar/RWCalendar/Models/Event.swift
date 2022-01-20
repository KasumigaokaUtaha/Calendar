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
    var remindingOffset: Double
}
