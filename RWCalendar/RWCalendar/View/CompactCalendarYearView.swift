//
//  CompactCalendarYearView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 02.01.22.
//

import SwiftUI

struct CompactCalendarYearView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State var currentYear = Calendar.current.component(.year, from: Date())
    private var columns = Array(repeating: GridItem(.flexible(minimum: 20.0)), count: 2)

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
        }
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
            LazyVGrid(columns: columns) {
                ForEach(fetchMonthData(for: year)) { monthData in
                    CompactCalendarMonthViewWrapper(
                        year: year,
                        month: monthData.month,
                        font: .system(.caption2)
                    )
                }
            }
        }
    }

    func fetchMonthData(for year: Int) -> [MonthData] {
        guard let yearData = store.state.years[year] else {
            return []
        }

        return yearData.months.values.sorted(by: { $0.month < $1.month })
    }
}
