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

    init(size: CGSize, columnsNumber: Int) {
        self.columnsNumber = columnsNumber

        let spacing = 30.0
        let totalSpacing = spacing * CGFloat(columnsNumber - 1)
        minimum = (size.width - totalSpacing) / CGFloat(columnsNumber)
        columns = Array(repeating: GridItem(.flexible(minimum: CGFloat(minimum))), count: columnsNumber)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(store.state.allYears, id: \.self) { year in
                        yearView(year: year)
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

    func yearView(year: Int) -> some View {
        Section {
            ForEach(fetchMonthData(for: year)) { monthData in
                CompactCalendarMonthViewWrapper(
                    year: year,
                    month: monthData.month,
                    font: .system(.caption2)
                )
            }
        } header: {
            VStack {
                Text(String(format: "%d", year))
                    .font(.system(.title))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
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
