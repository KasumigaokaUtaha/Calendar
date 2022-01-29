//
//  TrueMonthView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//
import EventKit
import Foundation
import SwiftUI

let days: [String] = Calendar.current.shortWeekdaySymbols
let dateArray = Array(repeating: GridItem(.flexible(minimum: 20)), count: 7)

struct TrueMonthView: View {
    @Binding var curDate: Date
    @State private var offset: CGSize = .zero
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData
    @State private var showEventMenu = false
    @State private var showSearchBar = false

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.custom(
                                customizationData.savedFontStyle,
                                size: CGFloat(customizationData.savedFontSize)
                            ))
                            .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                            .frame(maxWidth: .infinity)
                    }
                }

                LazyVGrid(columns: dateArray) {
                    ForEach(RWCalendar.getDate(date: curDate)) { value in
                        DateView(value: value)
                            .background(
                                Rectangle()
                                    .strokeBorder(lineWidth: 0.8)
                                    .background(Color(customizationData.selectedTheme.foregroundColor))
                                    .opacity(
                                        Calendar.current.isDate(value.date, inSameDayAs: curDate) && value
                                            .day != 0 ? 0.5 : 0
                                    )
                                    .padding(.horizontal, 8)
                            )
                            .onTapGesture {
                                curDate = value.date
                                store.send(.setSelectedDay(Calendar.current.component(.day, from: value.date)))
                                store.send(.setSelectedDate(value.date))
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
                                    curDate = Calendar.current.date(byAdding: .month, value: 1, to: curDate)!
                                    updateMonth()
                                }
                            } else if $0.startLocation.x < $0.location.x - 20 {
                                curDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
                                updateMonth()
                            }
                            self.offset = .zero
                        }
                )

                EventsListView()
                    .onAppear {
                        store.send(.loadEventsForMonth(at: curDate))
                    }
            }
            .onAppear {
                store.send(.loadEventsForMonth(at: curDate))
            }

            .navigationTitle(
                Text("\(RWCalendar.dateToString(date: curDate)[1]) \(RWCalendar.dateToString(date: curDate)[0])")
            )

            .navigationBarTitleDisplayMode(.inline)

            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    makeMenu()
                    Button(NSLocalizedString("today", comment: "Today")) {
                        curDate = Date()
                        store.send(.setSelectedDay(Calendar.current.component(.day, from: Date())))
                        store.send(.setSelectedDate(curDate))
                        store.send(.loadEventsForMonth(at: curDate))
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showEventMenu.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                    Button {
                        showSearchBar.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
        .sheet(isPresented: $showEventMenu) {
            AddEventsSheetView()
        }
        .sheet(isPresented: $showSearchBar) {
            EventSearchView(isPresented: $showSearchBar)
        }
    }

    var Font: UIFont {
        if
            let font = UIFont(
                name: customizationData.savedFontStyle,
                size: CGFloat(customizationData.savedFontSize)
            )
        {
            return font
        } else {
            return UIFont.systemFont(ofSize: 15)
        }
    }
}

struct MonthHome: View {
    @State var curDate = Date()

    var body: some View {
        VStack {
            TrueMonthView(curDate: $curDate)
        }
    }
}

struct TrueMonthView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    static var previews: some View {
        MonthHome(curDate: Date())
            .environmentObject(store)
            .onAppear {
                let rangeStart = store.state.currentYear - 1970
                store.send(.setScrollToToday(withAnimation: false))
                store.send(.loadYearDataRange(
                    base: store.state.currentYear,
                    range: -rangeStart ... 3
                ))
            }
    }
}

extension TrueMonthView {
    struct AddEventsSheetView: View {
        @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

        var body: some View {
            if store.state.defaultEventCalendar != nil {
                EventEditView(
                    nil,
                    defaultEventCalendar: store.state.defaultEventCalendar,
                    date: store.state.selectedDate
                )
            }
        }
    }

    func updateMonth() {
        store.send(.setSelectedDate(curDate))
        store.send(.loadEventsForMonth(at: curDate))
    }

    func makeMenu() -> some View {
        Menu {
            Button {
                store.send(.open(.year))
            } label: {
                Text(NSLocalizedString("year", comment: "Year"))
                Image(systemName: "calendar")
            }
            Button {
                store.send(.open(.month))
            } label: {
                Text(NSLocalizedString("month", comment: "Month"))
                Image(systemName: "calendar")
            }
            Button {
                store.send(.open(.week))
            } label: {
                Text(NSLocalizedString("week", comment: "Week"))
                Image(systemName: "calendar")
            }
            Button {
                store.send(.open(.day))
            } label: {
                Text(NSLocalizedString("day", comment: "Day"))
                Image(systemName: "calendar")
            }
            Divider()
            Button {
                store.send(.open(.settings))
            } label: {
                Text(NSLocalizedString("settings", comment: "Settings"))
                Image(systemName: "gear")
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }

    func checkEvent(date: Date) -> Bool {
        let key = RWDate(date: date, calendar: store.state.calendar)
        guard let eventIDs = store.state.dateToEventIDs[key] else {
            return false
        }

        return eventIDs.count > 0
    }

    @ViewBuilder
    func DateView(value: DateData) -> some View {
        VStack(spacing: 2) {
            if value.day != 0 {
                Text("\(value.day)")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                    .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                    .background(
                        Rectangle()
                            .strokeBorder(lineWidth: 0.8)
                            .background(Color(customizationData.selectedTheme.foregroundColor))
                            .opacity(
                                isToday(date: value.date) ? 0.5 : 0
                            )
                            .padding(.horizontal, 8)
                    )

                Circle()
                    .fill(
                        checkEvent(date: value.date) ?
                            Color(customizationData.selectedTheme.foregroundColor) : Color.white
                    )
                    .opacity(
                        checkEvent(date: value.date) ?
                            0.9 : 0
                    )
                    .frame(width: 7, height: 7)
            }
        }
    }
}
