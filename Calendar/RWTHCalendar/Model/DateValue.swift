//
//  DateValue.swift
//  RWTHCalendar
//
//  Created by Baichao Ye on 2022/1/1.
//

import SwiftUI

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day : Int
    var week: Int
    var date : Date
}
