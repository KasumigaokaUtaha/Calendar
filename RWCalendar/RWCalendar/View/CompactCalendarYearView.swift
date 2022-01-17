//
//  CompactCalendarYearView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 02.01.22.
//

import Combine
import SwiftUI

struct CompactCalendarYearView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    let columnsNumber: Int
    let columns: [GridItem]
    let minimum: CGFloat

    init(size: CGSize, columnsNumber: Int = 3) {
        self.columnsNumber = columnsNumber

        let spacing = 30.0
        let totalSpacing = spacing * CGFloat(columnsNumber - 1)
        minimum = (size.width - totalSpacing) / CGFloat(columnsNumber)
        columns = Array(repeating: GridItem(.flexible(minimum: CGFloat(minimum)), spacing: 0.0), count: columnsNumber)
    }

    var body: some View {
        ContainerView {
            makeScrollContent()
        }
    }

    /// Create a scroll view with all available years
    func makeScrollContent() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                    ForEach(store.state.allYears, id: \.self) { year in
                        makeYear(year)
                            .onAppear {
                                store.send(.loadYearDataIfNeeded(base: year))
                            }
                    }
                }
            }
            .onReceive(store.$state) { state in
                if state.scrollToToday, state.allYears.contains(state.currentYear) {
                    if state.isScrollToTodayAnimated {
                        withAnimation {
                            proxy.scrollTo(state.currentYear, anchor: .top)
                        }
                    } else {
                        proxy.scrollTo(state.currentYear, anchor: .top)
                    }
                    store.send(.resetScrollToDay)
                }
            }
        }
    }

    /// Create the compact year view for the given year
    func makeYear(_ year: Int) -> some View {
        Section {
            ForEach(fetchMonthData(for: year)) { monthData in
                CompactCalendarMonthViewWrapper(
                    year: year,
                    month: monthData.month,
                    font: .system(.caption2)
                )
            }
        } header: {
            Text(String(format: "%d", year))
                .font(.system(.title))
                .fontWeight(Font.Weight.medium)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func fetchMonthData(for year: Int) -> [MonthData] {
        guard let yearData = store.state.years[year] else {
            return []
        }

        return yearData.months.values.sorted(by: { $0.month < $1.month })
    }
}

struct AnotherYearView_Previews: PreviewProvider {
    static let store = AppStore(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())

    static var previews: some View {
        GeometryReader { proxy in
            CompactCalendarYearView(size: proxy.size, columnsNumber: 2)
                .environmentObject(store)
                .onAppear {
                    store.send(.loadYearDataRange(base: 2022, range: 0 ... 0))
                }
        }
    }
}
