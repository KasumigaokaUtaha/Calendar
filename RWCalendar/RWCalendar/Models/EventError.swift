//
//  EventError.swift
//  RWCalendar
//
//  Created by Liu on 19.01.22.
//

import Foundation

enum EventError: Error {
    case denied
    case restricted
    case notAdded
    case alreadyExists
}
