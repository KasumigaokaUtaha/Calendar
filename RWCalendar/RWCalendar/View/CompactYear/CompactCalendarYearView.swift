//
//  CompactCalendarYearView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 02.01.22.
//

import SwiftUI

struct CompactCalendarYearView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData

    @State var currentYear = Calendar.current.component(.year, from: Date())
    let column = GridItem(.flexible(minimum: 20.0))

    var body: some View {
        Group {
            if store.state.allYears.contains(currentYear) {
                makeContent()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if store.state.selectedYear != currentYear {
                currentYear = store.state.selectedYear
            }
            var dateComponent = store.state.calendar.dateComponents([.year], from: Date())
            dateComponent.year = currentYear
            dateComponent.month = 6
            dateComponent.day = 6
            let someDateInCurrentYear = store.state.calendar.date(from: dateComponent)!

            store.send(.loadEventsForYear(at: someDateInCurrentYear))
        }
    }

    var dayFont: UIFont {
        if
            let font = UIFont(
                name: customizationData.savedFontStyle,
                size: CGFloat(customizationData.savedFontSize)
            )
        {
            return font
        } else {
            return UIFont.systemFont(ofSize: 15)
        }
    }

    var monthFont: Font {
        Font.custom(
            customizationData.savedFontStyle,
            size: CGFloat(customizationData.savedFontSize + 5)
        )
    }

    func makeContent() -> some View {
        RWPageView(selection: $currentYear, indexDisplayMode: .always, indexBackgroundDisplayMode: .always) {
            ForEach(store.state.allYears, id: \.self) { year in
                makeYear(year)
                    .onAppear {
                        store.send(.loadYearDataIfNeeded(base: year))
                    }
            }
        }
        .onChange(of: currentYear) { value in
            if currentYear != store.state.selectedYear {
                store.send(.setSelectedYear(value))
            }
        }
        .onReceive(store.$state) { state in
            if state.scrollToToday {
                if state.isScrollToTodayAnimated {
                    withAnimation {
                        currentYear = state.currentYear
                    }
                } else {
                    currentYear = state.currentYear
                }

                store.send(.resetScrollToToDay)
            }
        }
        .navigationTitle(String(format: "%d", currentYear))
    }

    /// Create the compact year view for the given year
    func makeYear(_ year: Int) -> some View {
        ScrollView {
            LazyVGrid(columns: getColumns(for: customizationData.savedFontSize)) {
                ForEach(fetchMonthData(for: year)) { monthData in
                    CompactCalendarMonthViewWrapper(
                        year: year,
                        month: monthData.month,
                        dayFont: self.dayFont,
                        monthFont: self.monthFont,
                        theme: customizationData.selectedTheme
                    )
                }
            }
        }
    }

    func getColumns(for fontSize: Int) -> [GridItem] {
        var count = 2

        if fontSize < 13 {
            count = 3
        } else if fontSize > 17 {
            count = 1
        }

        return Array(repeating: column, count: count)
    }

    func fetchMonthData(for year: Int) -> [MonthData] {
        guard let yearData = store.state.years[year] else {
            return []
        }

        return yearData.months.values.sorted(by: { $0.month < $1.month })
    }
}
