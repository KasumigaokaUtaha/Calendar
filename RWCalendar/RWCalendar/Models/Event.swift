//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import CoreData
import Foundation

extension Event {
    
    enum EventError: Error {
        case NonUniqueID
        case IDNotFound
    }
}
