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

    // #TODO: add a var to controll light and dark modes
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.body)
                            .frame(maxWidth: .infinity)
                    }
                }

                // DateView
                LazyVGrid(columns: dateArray) {
                    ForEach(RWCalendar.getDate(date: curDate)) { value in
                        DateView(value: value)
                            .background(
                                Circle()
                                    .strokeBorder(lineWidth: 0.5)
                                    .background(Color.purple)
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
                .onAppear {
                    store.send(.loadEventsForMonth(at: curDate))
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
                                }
                            } else if $0.startLocation.x < $0.location.x - 20 {
                                curDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
                            }
                            self.offset = .zero
                        }
                )

                // EventView
                EventsListView()
            }
            .navigationTitle(Text("\(RWCalendar.dateToString(date: curDate)[1]) \(RWCalendar.dateToString(date: curDate)[0])"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    makeMenu()
                    Button("Today") {
                        curDate = Date()
                        store.send(.setSelectedDay(Calendar.current.component(.day, from: Date())))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEventMenu.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showEventMenu) {
            AddEventsSheetView()
        }
    }
}

struct MonthHome: View {
    @State var curDate = Date()

    var body: some View {
        VStack {
            TrueMonthView(curDate: $curDate)
            // .background(Color(CustomizationData().selectedTheme.backgroundColor))
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
    // subviews for title and dates
    var TitleView: some View {
        NavigationView {
            HStack {
                makeMenu()
                Button("Today") {
                    curDate = Date()
                    store.send(.setSelectedDay(Calendar.current.component(.day, from: Date())))
                }
                // years and months
                Text(RWCalendar.dateToString(date: curDate)[1])
                    .fontWeight(.bold)

                Text(RWCalendar.dateToString(date: curDate)[0])
                    .fontWeight(.bold)

                Button {
                    showEventMenu.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showEventMenu) {
                    AddEventsSheetView()
                }
            }
        }
        .frame(width: .infinity, height: 135, alignment: .topLeading)
    }

    struct AddEventsSheetView: View {
        @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
        // @State private var showEventMenu = false
        var body: some View {
            if store.state.defaultEventCalendar != nil {
                EventEditView(nil, defaultEventCalendar: store.state.defaultEventCalendar, date: store.state.selectedDate)
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
                    .foregroundColor(isToday(date: value.date) ? .blue : .primary)

                Circle()
                    .fill(
                        checkEvent(date: value.date) ?
                            Color.red : Color.white
                    )
                    .frame(width: 7, height: 7)
            }
        }
    }
}
