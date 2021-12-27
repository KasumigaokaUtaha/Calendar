//
//  AppAction.swift
//  Calendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Foundation

enum AppAction {
    case loadYearData(date: Date, range: ClosedRange<Int>)
    case setCurrentDate(date: Date)
}
