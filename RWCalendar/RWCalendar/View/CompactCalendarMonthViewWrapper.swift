//
//  CompactCalendarMonthViewWrapper.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import SwiftUI

/// A wrapper view of CompactCalendarMonthView
struct CompactCalendarMonthViewWrapper: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    let year: Int
    let month: Int

    let showLastMonthDays: Bool
    let showNextMonthDays: Bool
    let font: Font

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
        VStack(alignment: .center, spacing: 0) {
            Text("\(shortMonthSymbol)")
            CompactCalendarMonthView(
                font: .systemFont(ofSize: 10),
                lastMonthDays: lastMonthDays,
                currMonthDays: currMonthDays,
                nextMonthDays: nextMonthDays
            )
        }
    }

    var lastMonthDays: [String] {
        guard let monthData = getMonthData() else {
            return []
        }

        return monthData.lastMonthDays.map { "\($0.day)" }
    }

    var currMonthDays: [String] {
        guard let monthData = getMonthData() else {
            return []
        }

        return monthData.days.map { "\($0.day)" }
    }

    var nextMonthDays: [String] {
        guard let monthData = getMonthData() else {
            return []
        }

        return monthData.nextMonthDays.map { "\($0.day)" }
    }

    func getMonthData() -> MonthData? {
        guard
            let yearData = store.state.years[year],
            let monthData = yearData.months[month]
        else {
            return nil
        }

        return monthData
    }

    var shortMonthSymbol: String {
        let index = month - 1, shortMonthSymbols = store.state.calendar.shortMonthSymbols
        guard index >= 0, index < shortMonthSymbols.count else {
            return "Unknown"
        }
        return shortMonthSymbols[index]
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        CompactCalendarMonthViewWrapper(year: 2021, month: 12, showLastMonthDays: true, showNextMonthDays: true)
            .environmentObject(store)
            .onAppear {
                store.send(.loadYearDataRange(base: 2022, range: 0 ... 0))
            }
    }
}
