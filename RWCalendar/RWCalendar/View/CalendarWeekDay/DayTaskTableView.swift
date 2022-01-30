//
//  DayTaskTableView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import EventKitUI
import SwiftUI

// to draw the line of task table
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}

struct DayTaskTableView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @State private var showMiniEventList = false
    @EnvironmentObject var customizationData: CustomizationData
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    // get the events ids from the selected date
    var eventIDs: [String]? {
        guard let selectedDate = store.state.selectedDate else {
            return nil
        }

        guard let ids = store.state.dateToEventIDs[
            .init(date: selectedDate, calendar: store.state.calendar)
        ] else {
            return nil
        }

        let idSet = Set(ids)

        let idArr = Array(idSet)

        return idArr
    }

    // according the events IDs get the events
    func events(with eventIDs: [String]) -> [Event] {
        var events: [Event] = []
        for eventID in eventIDs {
            if let event = store.state.eventIDToEvent[eventID] {
                if store.state.recurringEventIDs.contains(eventID) {
                    guard
                        let selectedDate = store.state.selectedDate,
                        let recurrenceRule = event.recurrenceRule,
                        let nextRecurringEvent = Util.nextRecurringEvent(
                            for: event,
                            at: selectedDate,
                            with: recurrenceRule,
                            calendar: store.state.calendar
                        )
                    else {
                        continue
                    }

                    events.append(nextRecurringEvent)
                } else {
                    events.append(event)
                }
            }
        }
        var events_selectedDay: [Event] = []
        let todayMinDate = store.state.calendar.startOfDay(for: store.state.selectedDate!)
        let todayMaxDate = store.state.calendar.date(byAdding: .day, value: 1, to: todayMinDate)!
        for event in events {
            if event.startDate < todayMinDate, event.endDate > todayMaxDate {
                var modified_event = event
                modified_event.startDate = todayMinDate
                modified_event.endDate = todayMaxDate
                events_selectedDay.append(modified_event)
                continue
            } else if event.startDate < todayMinDate {
                var modified_event = event
                modified_event.startDate = todayMinDate
                events_selectedDay.append(modified_event)
                continue
            } else if event.endDate > todayMaxDate {
                var modified_event = event
                modified_event.endDate = todayMaxDate
                events_selectedDay.append(modified_event)
                continue
            } else {
                events_selectedDay.append(event)
                continue
            }
        }

        return events_selectedDay
    }

    // accroding the events get the taskcard, to be showed in the day task view
    func eventsToTaskCards(events: [Event]) -> [TaskCard] {
        var taskCards: [TaskCard] = []
        let events_sorted = events.sorted { $0.startDate < $1.startDate }
        for event in events_sorted {
            var addNewCard = false
            if taskCards.count == 0 {
                var newCard = TaskCard(cardStartingTime: event.startDate, cardEndingTime: event.endDate)
                newCard.events_set.insert(event)
                taskCards.append(newCard)
                continue
            }

            for i in taskCards.indices {
                if event.startDate < taskCards[i].cardEndingTime {
                    taskCards[i].events_set.insert(event)
                    taskCards[i].cardEndingTime = event.endDate > taskCards[i].cardEndingTime ? event.endDate : taskCards[i].cardEndingTime

                    break
                }

                if i == taskCards.count - 1 {
                    addNewCard = true
                }
            }

            if addNewCard {
                var newCard = TaskCard(cardStartingTime: event.startDate, cardEndingTime: event.endDate)
                newCard.events_set.insert(event)
                taskCards.append(newCard)
                continue
            }
        }

        return taskCards
    }

    // get the size of Scroll view, help to draw the task card
    func getScrollViewHeight(geo: GeometryProxy) -> Double {
        return (geo.size.height / 15 * 24 + 20 * 25)
    }

    // get the middle time point, help to find the center of the task card view
    func getMiddleTime(date1: Date, date2: Date) -> Double {
        let calendar = store.state.calendar
        let m1 = calendar.component(.minute, from: date1)
        let h1 = calendar.component(.hour, from: date1)
        let m2 = calendar.component(.minute, from: date2)
        let h2: Int
        if calendar.startOfDay(for: date2) > calendar.startOfDay(for: date1) {
            h2 = 24
        } else {
            h2 = calendar.component(.hour, from: date2)
        }

        return Double((h1 + h2) * 60 + m2 + m1) / 120
    }

    func getFrameWidth(geo: GeometryProxy, taskCard: TaskCard) -> Double {
        return Double((Int(geo.size.width) - 80) / taskCard.events.count)
    }

    func getCardPosition(geo: GeometryProxy, taskCard: TaskCard) -> Double {
        return Double(CGFloat((Int(geo.size.width) - 80) / (taskCard.events.count * 2)))
    }

    // to show the task card view
    func taskCardView(taskCards: [TaskCard], geo: GeometryProxy) -> some View {
        print(taskCards.count)
        func getViewHeigt(event: Event) -> Double {
            let ideaHeight = (getScrollViewHeight(geo: geo) - 20) / 24 * (event.endDate.timeIntervalSinceReferenceDate - event.startDate.timeIntervalSinceReferenceDate) / 3600
            // set the mininum height of view
            return ideaHeight < 30 ? 30 : ideaHeight
        }

        func getViewY(event: Event) -> Double {
            return (getScrollViewHeight(geo: geo) - 20) / 24 * getMiddleTime(date1: event.startDate, date2: event.endDate) + 10
        }

        return (ForEach(taskCards, id: \.self) { taskCard in
            HStack {
                Spacer(minLength: 80)
                ForEach(taskCard.events.indices, id: \.self) { id in
                    let event = taskCard.events[id]
                    Text("\(event.title)")
                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                        .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                        .frame(width: getFrameWidth(geo: geo, taskCard: taskCard), height: 20, alignment: .topLeading)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color(cgColor: event.calendar.cgColor))
                        )
                        .frame(width: getFrameWidth(geo: geo, taskCard: taskCard), height: getViewHeigt(event: event), alignment: .topLeading)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color(cgColor: event.calendar.cgColor).opacity(0.6)))
                        .position(x: getCardPosition(geo: geo, taskCard: taskCard), y: getViewY(event: event))
                        .onTapGesture {
                            store.send(.setSelectedEvent(event))
                            showMiniEventList.toggle()
                        }
                }
                .sheet(isPresented: $showMiniEventList) {
                    EventDisplayView()
                }
            }
        })
    }

    @ViewBuilder
    func getCardView(eventsIds: [String]?, geo: GeometryProxy) -> some View {
        if let eventIDs = eventsIds {
            if eventIDs.count > 0 {
                taskCardView(taskCards: eventsToTaskCards(events: events(with: eventsIds!)), geo: geo)
            }
        }
    }

    /// the task view make up time table( base converage) and the task card view
    /// the card view are some tasks happen at same time period ( if the start time between the time of other taks)
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: true) {
                ZStack {
                    VStack(spacing: geo.size.height / 15) {
                        ForEach(0...12, id: \.self) { row in
                            HStack(spacing: 10) {
                                Text("\(row) : 00 AM")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                    .frame(width: 70)

                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 0.5))
                                    .fill(.gray)
                                    .frame(height: 1)
                            }
                        }.frame(width: geo.size.width, height: 20, alignment: .leading)

                        ForEach(13...24, id: \.self) { row in
                            HStack(spacing: 10) {
                                Text("\(row) : 00 PM")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                    .frame(width: 70)

                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 0.5))
                                    .fill(.gray)
                                    .frame(height: 1)
                            }
                        }.frame(width: geo.size.width, height: 20, alignment: .leading)
                    }
                    .frame(width: geo.frame(in: .local).width, alignment: .leading)
                    getCardView(eventsIds: eventIDs, geo: geo)
                }
            }
            .onReceive(store.$state) { _ in
            }
            .onAppear {
                store.send(.loadEventsForDay(at: store.state.selectedDate ?? Date()))
            }
        }
    }
}

// to avoid add duplicate events, use set to collect the events and copy it with array
struct TaskCard: Hashable {
    var events_set: Set<Event> = []
    var cardStartingTime: Date
    var cardEndingTime: Date
    var events: [Event] {
        return Array(events_set).sorted(by: { $0.startDate < $1.startDate })
    }
}

struct DayTaskTableView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        DayTaskTableView()
            .environmentObject(store)
    }
}
