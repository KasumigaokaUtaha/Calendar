//
//  DateDatabase.swift
//  IOSCalender
//
//  Created by Liangkun He on 06.01.22.
//

import Foundation

struct DateData: Identifiable{
    var day: Int
    var date: Date
    var id =  UUID().uuidString
    
}
