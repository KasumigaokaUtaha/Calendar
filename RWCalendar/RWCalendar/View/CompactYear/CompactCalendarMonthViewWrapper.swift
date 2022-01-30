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

    let dayFont: UIFont
    let monthFont: Font
    let theme: Theme

    init(
        year: Int,
        month: Int,
        showLastMonthDays: Bool = false,
        showNextMonthDays: Bool = false,
        dayFont: UIFont = .preferredFont(forTextStyle: .body),
        monthFont: Font = .title3,
        theme: Theme = Theme0()
    ) {
        self.year = year
        self.month = month
        self.showLastMonthDays = showLastMonthDays
        self.showNextMonthDays = showNextMonthDays
        self.dayFont = dayFont
        self.monthFont = monthFont
        self.theme = theme
    }

    var body: some View {
        Button {
            store.send(.setSelectedMonth(month))
            store.send(.open(.month))
        } label: {
            VStack(alignment: .center, spacing: 0) {
                Text("\(shortMonthSymbol)")
                    .font(monthFont)
                CompactCalendarMonthView(
                    font: self.dayFont,
                    theme: self.theme,
                    lastMonthDays: lastMonthDays,
                    currMonthDays: currMonthDays,
                    nextMonthDays: nextMonthDays,
                    currMonthDayStyles: currMonthDayStyles
                )
            }
        }
    }
}

extension CompactCalendarMonthViewWrapper {
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

    var currMonthDayStyles: [TextBoxStyle?] {
        guard let monthData = getMonthData() else {
            return []
        }

        return monthData.days
            .map { day in store.state.calendar.isDate(day.date, inSameDayAs: Date()) ? TextBoxStyle() : nil }
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
