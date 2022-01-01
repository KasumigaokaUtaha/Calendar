//
//  ShortMonthView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import SwiftUI

struct ShortMonthView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    let year: Int
    let month: Int

    let showLastMonthDays: Bool
    let showNextMonthDays: Bool
    let font: Font
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

    init(
        year: Int,
        month: Int,
        showLastMonthDays: Bool = false,
        showNextMonthDays: Bool = false,
        font: Font = .system(.body)
    ) {
        self.year = year
        self.month = month
        self.showLastMonthDays = showLastMonthDays
        self.showNextMonthDays = showNextMonthDays
        self.font = font
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(shortMonthSymbol)")
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 8,
                pinnedViews: []
            ) {
                ForEach(self.daysData) { dayData in
                    Group {
                        if isInCurrentMonth(date: dayData.date) {
                            Text("\(dayData.day)")
                        } else {
                            if dayData.date < date(year: year, month: month) {
                                Text("\(showLastMonthDays ? String(dayData.day) : "")")
                            } else {
                                Text("\(showNextMonthDays ? String(dayData.day) : "")")
                            }
                        }
                    }
                    .foregroundColor(isInCurrentMonth(date: dayData.date) ? Color.primary : Color.secondary)
                    .font(self.font)
                }
            }
        }
    }

    var daysData: [DayData] {
        guard
            let yearData = store.state.years[year],
            let monthData = yearData.months[month]
        else {
            return []
        }

        let lastMonthDays = monthData.lastMonthDays
        let nextMonthDays = monthData.nextMonthDays
        return lastMonthDays + monthData.days + nextMonthDays
    }

    var monthSymbol: String {
        let index = month - 1, monthSymbols = store.state.calendar.monthSymbols
        guard index >= 0, index < monthSymbols.count else {
            return "Unknown"
        }
        return monthSymbols[index]
    }

    var shortMonthSymbol: String {
        let index = month - 1, shortMonthSymbols = store.state.calendar.shortMonthSymbols
        guard index >= 0, index < shortMonthSymbols.count else {
            return "Unknown"
        }
        return shortMonthSymbols[index]
    }

    var shortWeekdaySymbols: [String] {
        store.state.calendar.shortWeekdaySymbols
    }

    func isInCurrentMonth(date: Date) -> Bool {
        let month = store.state.calendar.component(.month, from: date)
        return month == self.month
    }

    func date(year: Int, month: Int) -> Date {
        store.state.calendar.date(from: .init(year: year, month: month))!
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        ShortMonthView(year: 2021, month: 12, showLastMonthDays: true, showNextMonthDays: true)
            .environmentObject(store)
            .onAppear {
                store.send(.loadYearData(date: Date(), range: 0 ... 0))
            }
    }
}
