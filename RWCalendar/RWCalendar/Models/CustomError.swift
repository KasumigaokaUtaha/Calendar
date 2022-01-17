//
//  CustomError.swift
//  RWCalendar
//
//  Created by Liu on 16.01.22.
//

import Foundation

enum CustomError: Error {
    case calendarAccessDeniedOrRestricted
    case eventNotAddedToCalendar
    case eventAlreadyExistsInCalendar
}
