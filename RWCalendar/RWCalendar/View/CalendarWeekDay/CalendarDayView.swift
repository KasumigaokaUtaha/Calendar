//
//  CalendarDayView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct CalendarDayView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @State private var currentWeek: Int = 0
    
    let weekDays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
        DayToolbarView()
    }
}

struct CalendarDayView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayView()
    }
}
