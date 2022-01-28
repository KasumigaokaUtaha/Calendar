//
//  DayToolbarView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

// to show the tool bar of day view (week table and current date)
struct DayToolbarView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @Binding var currentWeek: Int
    @State private var offset: CGSize = .zero
    @State var selectedDate: Date = .init()
    var weekDays :[String]{
        return store.state.calendar.shortWeekdaySymbols
    }
    var body: some View {
        DayDataView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    makeMenu()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    DayAddEvent()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    makeButton()
                }
            }
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
                store.send(.open(.week))
            } label: {
                Text("Week")
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
            selectedDate = Date()
            let day = Calendar.current.component(.day, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let year = Calendar.current.component(.year, from: Date())
            store.send(.setSelectedDay(day))
            store.send(.setSelectedMonth(month))
            store.send(.setSelectedYear(year))
            store.send(.setSelectedDate(Date()))
        } label: {
            Text("Today")
        }
    }
    
    func getWeekFrame(currentWeek: Int) -> some View {
        ForEach(0...6, id: \.self) {
            let d = extractDate(currentWeek: currentWeek)[$0]
            Button(String(d.day)) {
                let date = d.date
                let calendar = Calendar.current
                store.send(.setSelectedYear(calendar.component(.year, from: date)))
                store.send(.setSelectedMonth(calendar.component(.month, from: date)))
                store.send(.setSelectedDay(calendar.component(.day, from: date)))
                store.send(.setSelectedDate(date))
            }
            .buttonStyle(StaticButtonStyle())
            .background(Circle()
                .fill(Color.red)
                .opacity(isSameDayToSelectedDay(date1: d.date) ? 1 : 0)
                .frame(width: 25, height: 25)
            )
        }.onAppear{
            store.send(.loadEventsForYear(at: Date()))
        }
    }
    
    // get the month, year, week
    func getDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        
        let calendar = Calendar.current
        var d = store.state.currentDate
        d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!
        
        var MonthAndYear = formatter.string(from: d)
        
        // date[0]: years... date[1]: month ... date[2]: weeksnumber of year
        var date = MonthAndYear.components(separatedBy: " ")
        
        let weekOfYear = calendar.component(.weekOfYear, from: d)
        date.append(String(weekOfYear))
        
        return date
    }
    
    func isSameDayToSelectedDay(date1: Date) -> Bool {
        let calendar = Calendar.current
        var dc = DateComponents()
        dc.year = store.state.selectedYear
        dc.month = store.state.selectedMonth
        dc.day = store.state.selectedDay
        
        let d2 = calendar.date(from: dc)!
        
        return calendar.isDate(date1, inSameDayAs: store.state.selectedDate!)
    }
    
    // accoding the current week number of the year get the corresponding dates list (for 7 days)
    func extractDate(currentWeek: Int) -> [DayData] {
        let days = store.state.currentDate.getWeekDate(currentWeek: currentWeek)
        
        let calendar = Calendar.current
        
        return days.compactMap { date -> DayData in
            let day = calendar.component(.day, from: date)
            let week = calendar.component(.weekOfYear, from: date)
            
            return DayData(day: day, date: date, weekday: Weekday(week, calendar: Calendar.current) ?? Weekday.monday)
        }
    }
    
    func getToolBarData(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy MMM"
        let calendar = Calendar.current
        let d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: date)!
        return df.string(from: d)
    }
}

extension DayToolbarView {
    var DayDataView: some View {
        VStack(spacing: 1) {
            HStack {
                ForEach(0...6, id: \.self) { day in
                    Text(weekDays[day])
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    // *******
                }
            }.frame(maxWidth: .infinity)
            HStack {
                getWeekFrame(currentWeek: currentWeek)
                    .offset(x: offset.width)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 30, alignment: .bottom)
        .highPriorityGesture(
            DragGesture(coordinateSpace: .local)
                .onChanged {
                    self.offset = $0.translation
                }
                .onEnded {
                    if $0.startLocation.x > $0.location.x + 20 {
                        withAnimation {
                            self.currentWeek += 1
                        }
                        
                    } else if $0.startLocation.x < $0.location.x - 20 {
                        withAnimation {
                            self.currentWeek -= 1
                        }
                    }
                    self.offset = .zero
                }
        )
        .navigationTitle(getToolBarData(date: store.state.currentDate))
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

// struct DayToolbarView_Previews: PreviewProvider {
//    @State var currentWeek:Int = 0
//    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
//        initialState: AppState(),
//        reducer: appReducer,
//        environment: AppEnvironment()
//    )
//
//    static var previews: some View {
//
//        DayToolbarView(currentWeek: 0)
//            .environmentObject(store)
//    }
// }
