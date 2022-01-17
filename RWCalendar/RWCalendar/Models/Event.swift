//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import CoreData
import Foundation

struct Event {
    var name: String
    var dateStart: Date
    var dateEnd: Date
    var description: String
    var remindingOffset: Double
    
    enum EventError: Error {
        case NonUniqueID
        case IDNotFound
    }
}
