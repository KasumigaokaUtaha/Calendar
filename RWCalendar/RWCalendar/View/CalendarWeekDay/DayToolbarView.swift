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
    @State var showSearchBar: Bool = false
    @EnvironmentObject var customizationData: CustomizationData
    var weekDays: [String] {
        return store.state.calendar.shortWeekdaySymbols
    }

    var body: some View {
        DayDataView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    makeMenu()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    makeButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    DayAddEvent()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSearchBar.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }.sheet(isPresented: $showSearchBar) {
                EventSearchView(isPresented: $showSearchBar)
            }
    }

    // to switch the view
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

    // reset the selected to today and reset the view to today
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
        }.onAppear {
            store.send(.loadEventsForMonth(at: store.state.selectedDate ?? Date()))
        }
    }
    
    // get the month, year, week
    func getDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        
        let calendar = store.state.calendar
        var d = store.state.currentDate
        d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!
        
        let MonthAndYear = formatter.string(from: d)
        
        // date[0]: years... date[1]: month ... date[2]: weeksnumber of year
        var date = MonthAndYear.components(separatedBy: " ")
        
        let weekOfYear = calendar.component(.weekOfYear, from: d)
        date.append(String(weekOfYear))
        
        return date
    }

    // to check the date and mark the selected date
    func isSameDayToSelectedDay(date1: Date) -> Bool {
        let calendar = Calendar.current
        var dc = DateComponents()
        dc.year = store.state.selectedYear
        dc.month = store.state.selectedMonth
        dc.day = store.state.selectedDay
        
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

    // to set tool bar title of day view
    func getToolBarData(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM yyyy"
        let calendar = Calendar.current
        let d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: date)!
        return df.string(from: d)
    }
}

extension DayToolbarView {
    var DayDataView: some View {
        VStack(spacing: 5) {
            VStack(spacing: 0) {
                HStack {
                    ForEach(0...6, id: \.self) { day in
                        Text(weekDays[day])
                            .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                            .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
//                            .font(.callout)
//                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        // *******
                    }
                }.frame(maxWidth: .infinity)
                HStack {
                    getWeekFrame(currentWeek: currentWeek)
                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                        .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
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
            
            HStack(spacing: 0) {
                Text("  ")
                Text(" Week:\(getDate()[2]) ")
                    .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                    .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                    .frame(height: 20)
                    .background(RoundedRectangle(cornerRadius: 4).fill(.yellow))
                Spacer()
            }.frame(height: 10)
        }
        
        .navigationTitle(getToolBarData(date: store.state.currentDate))
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
