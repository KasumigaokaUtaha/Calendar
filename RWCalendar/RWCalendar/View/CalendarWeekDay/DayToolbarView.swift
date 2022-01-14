//
//  DayToolbarView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct DayToolbarView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @State private var currentWeek: Int = 0
    @State private var offset: CGSize = .zero
    var body: some View {
        let weekDays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        NavigationView {
            GeometryReader { _ in
                VStack(spacing: 0) {
//                    DayTaskTableView()
                    ScrollView {
                        Da
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 3) {
                        Spacer()
                        HStack {
                            Text("\(getToolBarData(date: store.state.currentDate)[0]) \(getToolBarData(date: store.state.currentDate)[1])")
                                .foregroundColor(Color.red)
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Button("Today") {
                                store.send(.setScrollToToday(withAnimation: true))
                            }
                        }
                        VStack(spacing: 0) {
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
                                ForEach(0...6, id: \.self) {
                                    let d = extractDate()[$0]
                                    Text(String(d.day))
                                        .background(Circle()
                                                        .fill(Color.red)
                                                        .opacity(isSameDay(date1:d.date , date2: store.state.currentDate) ? 1:0)
                                                        .frame(width: 25, height: 25)
                                        )
                                }
                                
                                .frame(maxWidth: .infinity)
                                .offset(x: offset.width * 3)
                                .gesture(
                                    DragGesture()
                                        .onChanged{
                                            print("changing")
                                            self.offset = $0.translation
                                            if offset.width > 100 {
                                                self.currentWeek += 1
                                            } else if offset.width < -100 {
                                                self.currentWeek -= 1
                                            }
                                        }
                                        .onEnded { _ in
                                            print("changing")
                                            if offset.width > 100 {
                                                self.currentWeek += 1
                                            } else if offset.width < -100 {
                                                self.currentWeek -= 1
                                            }
                                        }
                                )
                            }
                        }
                        Text(store.state.currentDate, style: .date)
                            .font(.footnote)
                    }
                }

            })
        }.navigationBarTitle(" ", displayMode: .inline)
    }
    
    // get the month, year, week
    func getDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        
        let calendar = Calendar.current
        var d = store.state.currentDate
        d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!
        
        var MonthAndYear = formatter.string(from: d)
        
        var date = MonthAndYear.components(separatedBy: " ")
        
        let weekOfYear = calendar.component(.weekOfYear, from: d)
        date.append(String(weekOfYear))
        
        return date
    }
    
    
    
    func isSameDay(date1:Date, date2:Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1,inSameDayAs: date2)
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
    
        return df.string(from: date).components(separatedBy: "-")
    }
}

struct DayToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        DayToolbarView()
    }
}

// extension Date to get the whole week
extension Date {
    func getWeeks(currentWeek: Int) -> [Date] {
        print(currentWeek)
        // the local calendar
        let calendar = Calendar.current
        
        let range = 1...7
        
        // getting the start Date
        
        var startDay = calendar.date(from: Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self))!
        startDay = calendar.date(byAdding: .hour, value: 2, to: startDay) ?? Date()
        startDay = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: startDay)!
        // get date...
        // 把Int转换成具体的日期
        
        return range.compactMap { weekday -> Date in
            calendar.date(byAdding: .day, value: weekday - 1, to: startDay) ?? Date()
        }
    }
}
