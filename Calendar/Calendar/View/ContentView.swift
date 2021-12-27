//
//  ContentView.swift
//  Calendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(2020 ... 2022, id: \.self) { year in
                    CalendarYearView(year: year)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Today")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalendarYearView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 32, alignment: nil), count: 2)
    let year: Int

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                Section {
                    ForEach(1 ... 12, id: \.self) { month in
                        CalendarMonthView(month: month)
                            .frame(height: 200)
                    }
                } header: {
                    HStack {
                        Text(String(format: "%d 年", year))
                            .font(.system(.title3))
                            .padding(.leading, 8)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct CalendarMonthView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 20), spacing: nil, alignment: nil), count: 7)
    let month: Int

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8, pinnedViews: []) {
            Section {
                ForEach(1 ... 30, id: \.self) { day in
                    Text("\(day)")
                        .font(.system(.callout))
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
}
