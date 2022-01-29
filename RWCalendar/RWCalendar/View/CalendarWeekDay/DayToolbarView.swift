//
//  DayToolbarView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct DayToolbarView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @State private var currentWeek = 0
    @State private var offset: CGSize = .zero
    let weekDays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
        NavigationView {
            VStack {
                makeDayBarView()
                Spacer(minLength: 20)
                DayTaskTableView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    makeMenu()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    makeButton()
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    func makeDayBarView() -> some View {
        VStack(spacing: 1) {
            HStack {
                ForEach(0 ... 6, id: \.self) { day in
                    Text(weekDays[day])
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    // *******
                }
            }.frame(maxWidth: .infinity)
            HStack {
                ForEach(0 ... 6, id: \.self) {
                    let d = extractDate()[$0]
                    Text(String(d.day))
                        .background(
                            Circle()
                                .fill(Color.red)
                                .opacity(isSameDay(date1: d.date, date2: store.state.currentDate) ? 1 : 0)
                                .frame(width: 25, height: 25)
                        )
                }.frame(maxWidth: .infinity)
                    .offset(x: offset.width * 3)
            }
        }
        .frame(height: 30, alignment: .bottom)
        .gesture(
            DragGesture(coordinateSpace: .local)
                .onChanged {
                    self.offset = $0.translation
                }
                .onEnded {
                    if $0.startLocation.x - 50 > $0.location.x {
                        self.currentWeek += 1
                    } else if $0.startLocation.x + 50 < $0.location.x {
                        self.currentWeek -= 1
                    }
                    self.offset = .zero
                }
        )
        .navigationTitle(
            "\(getToolBarData(date: store.state.currentDate)[0]) \(getToolBarData(date: store.state.currentDate)[1])"
        )
    }

    func makeMenu() -> some View {
        Menu {
            Button {
                store.send(.open(.year))
            } label: {
                Text("Year")
                Image(systemName: "calendar")
            }
            Button {
                store.send(.open(.month))
            } label: {
                Text("Month")
                Image(systemName: "calendar")
            }
            Button {
                store.send(.open(.day))
            } label: {
                Text("Day")
                Image(systemName: "calendar")
            }
            Divider()
            Button {
                store.send(.open(.settings))
            } label: {
                Text("Settings")
                Image(systemName: "gear")
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }

    func makeButton() -> some View {
        Button {
            currentWeek = 0
        } label: {
            Text("Today")
        }
    }

    // get the month, year, week
    func getDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"

        let calendar = Calendar.current
        var d = store.state.currentDate
        d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!

        let MonthAndYear = formatter.string(from: d)

        var date = MonthAndYear.components(separatedBy: " ")

        let weekOfYear = calendar.component(.weekOfYear, from: d)
        date.append(String(weekOfYear))

        return date
    }

    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(date1, inSameDayAs: date2)
    }

    func extractDate() -> [DayData] {
        let days = store.state.currentDate.getWeeks(currentWeek: currentWeek)

        let calendar = Calendar.current

        return days.compactMap { date -> DayData in
            let day = calendar.component(.day, from: date)
            let week = calendar.component(.weekOfYear, from: date)

            return DayData(day: day, date: date, weekday: Weekday(week, calendar: Calendar.current) ?? Weekday.monday)
        }
    }

    func getToolBarData(date: Date) -> [String] {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MMM"
        let calendar = Calendar.current
        let d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: date)!
        return df.string(from: d).components(separatedBy: "-")
    }
}

struct DayToolbarView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        DayToolbarView()
            .environmentObject(store)
    }
}

// extension Date to get the whole week
extension Date {
    func getWeeks(currentWeek: Int) -> [Date] {
        // the local calendar
        let calendar = Calendar.current

        let range = 1 ... 7

        // getting the start Date

        var startDay = calendar
            .date(from: Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self))!
        startDay = calendar.date(byAdding: .hour, value: 2, to: startDay) ?? Date()
        startDay = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: startDay)!
        // get date...

        return range.compactMap { weekday -> Date in
            calendar.date(byAdding: .day, value: weekday - 1, to: startDay) ?? Date()
        }
    }
}
