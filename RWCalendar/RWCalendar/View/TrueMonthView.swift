//
//  TrueMonthView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//

import Foundation
import SwiftUI

let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
let dateArray = Array(repeating: GridItem(.flexible()), count: 7)

struct TrueMonthView: View {
    @Binding var curDate: Date
    @State private var offset: CGSize = .zero
    @State var curMonth = 0
    // #TODO: add a var to controll light and dark modes

    var body: some View {
        VStack {
            TitleView

            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.body)
                        .frame(maxWidth: .infinity)
                }
            }

            DateView

            Spacer()
        }
    }
}

struct MonthHome: View {
    @State var curDate = Date()

    var body: some View {
        TrueMonthView(curDate: $curDate)
    }
}

struct TrueMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthHome()
    }
}

extension Date {
    func getMonthDate() -> [Date] {
        let range = Calendar.current.range(of: .day, in: .month, for: self)!

        let starter = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!

        return range.compactMap { day -> Date in
            Calendar.current.date(byAdding: .day, value: day - 1, to: starter)!
        }
    }
}

extension TrueMonthView {
    // subviews for title and dates
    var TitleView: some View {
        NavigationView {
            HStack {
                Menu {
                    // #TODO: add menu that displays a list of other views and setting
                    Text("add navilinks to other views")
                } label: {
                    Label("", systemImage: "pencil")
                }

                Button("Today") {
                    curMonth = 0
                }
                // years and months

                Text(dateToString()[1])
                    .fontWeight(.bold)

                Text(dateToString()[0])
                    .fontWeight(.bold)

                Menu {
                    // #TODO: add event menu that collabs with event view
                    Text("add navilinks to add events")
                } label: {
                    Label("", systemImage: "pencil")
                }
            }
        }
        .frame(width: .infinity, height: 150, alignment: .topLeading)
    }

    var DateView: some View {
        LazyVGrid(columns: dateArray, spacing: 25) {
            ForEach(getDate()) { value in

                VStack {
                    if value.day != 0 {
                        Text("\(value.day)")
                            .foregroundColor(isToday(date: value.date) ? .blue : .none)
                    }
                }
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .local)
                .onChanged {
                    self.offset = $0.translation
                }
                .onEnded {
                    if $0.startLocation.x > $0.location.x + 20 {
                        withAnimation {
                            curMonth += 1
                        }
                    } else if $0.startLocation.x < $0.location.x - 20 {
                        curMonth -= 1
                    }
                    self.offset = .zero
                }
        )
        .padding()
        .onChange(of: curMonth) { _ in
            curDate = getCurMonth()
        }
    }

    // helping functions

    func dateToString() -> [String] {
        let month = Calendar.current.component(.month, from: curDate) - 1
        let year = Calendar.current.component(.year, from: curDate)

        return ["\(year)", Calendar.current.shortMonthSymbols[month]]
    }

    func getCurMonth() -> Date {
        Calendar.current.date(byAdding: .month, value: curMonth, to: Date())!
    }

    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    func getDate() -> [DateData] {
        var days = getCurMonth().getMonthDate().compactMap { date -> DateData in

            let day = Calendar.current.component(.day, from: date)

            return DateData(day: day, date: date)
        }

        let firstWeek = Calendar.current.component(.weekday, from: days.first!.date)

        for _ in 0 ..< firstWeek - 1 {
            // offset: set extra dates as 0
            days.insert(DateData(day: 0, date: Date()), at: 0)
        }

        return days
    }
}
