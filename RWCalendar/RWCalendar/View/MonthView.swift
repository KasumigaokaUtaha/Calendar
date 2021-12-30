//
//  MonthView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import SwiftUI

struct MonthView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 20), spacing: nil, alignment: nil), count: 7)
    let year: Int
    let month: Int

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8, pinnedViews: []) {
            Section {
                ForEach(self.daysData) { dayData in
                    Text("\(dayData.day)")
                        .foregroundColor(isInCurrentMonth(date: dayData.date) ? Color.primary : Color.secondary)
                        .font(.system(.body))
                        .fontWeight(.bold)
                }
            } header: {
                HStack {
                    Text("\(month) 月")
                        .padding(.leading, 4)
                    Spacer()
                }
            }
        }
    }

    var daysData: [DayData] {
        if let yearData = store.state.years[year], let monthData = yearData.months[month] {
            let lastMonthDays = monthData.lastMonthDays
            return lastMonthDays + monthData.days
        }
        return []
    }

    func isInCurrentMonth(date: Date) -> Bool {
        let month = store.state.calendar.component(.month, from: date)
        return month == self.month
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())
        MonthView(year: 2021, month: 12)
            .environmentObject(store)
            .onAppear {
                store.send(.loadYearData(date: Date(), range: 0 ... 0))
            }
    }
}
