//
//  YearView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 01.01.22.
//

import SwiftUI

struct YearView: View {
    let year: Int
    let monthColumnCount: Int

    init(year: Int, monthColumnCount: Int) {
        self.year = year
        self.monthColumnCount = monthColumnCount
    }

    var body: some View {
        GeometryReader { proxy in
            let spacing = 30
            let minimum = (Int(proxy.size.width) - spacing * (monthColumnCount - 1)) / monthColumnCount
            ScrollView {
                LazyVGrid(columns: Array(
                    repeating: .init(.flexible(minimum: CGFloat(minimum))),
                    count: monthColumnCount
                )) {
                    Section {
                        ForEach(1 ... 12, id: \.self) { month in
                            ShortMonthView(year: year, month: month, font: .system(.caption))
                        }
                    } header: {
                        VStack {
                            Text(String(format: "%d", year))
                                .font(.system(.title3))
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

struct YearView_Previews: PreviewProvider {
    static let store = AppStore(initialState: AppState(), reducer: appReducer, environment: AppEnvironment())

    static var previews: some View {
        YearView(year: 2022, monthColumnCount: 3)
            .environmentObject(store)
            .onAppear {
                store.send(.loadYearData(date: Date(), range: 0 ... 0))
            }
    }
}
