//
//  TrueMonthView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//
import Foundation
import SwiftUI

let days: [String] = Calendar.current.shortWeekdaySymbols
let dateArray = Array(repeating: GridItem(.flexible()), count: 7)

struct TrueMonthView: View {
    @Binding var curDate: Date
    @State private var offset: CGSize = .zero
    // @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

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
        VStack {
            TrueMonthView(curDate: $curDate)
        }
    }
}

struct TrueMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthHome(curDate: Date())
    }
}

extension TrueMonthView {
    // subviews for title and dates
    var TitleView: some View {
        NavigationView {
            HStack {
                Button("Today") {
                    curDate = Date()
                }
                // years and months
                Text(RWCalendar.dateToString(date: curDate)[1])
                    .fontWeight(.bold)

                Text(RWCalendar.dateToString(date: curDate)[0])
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
            ForEach(RWCalendar.getDate(date: curDate)) { value in

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
                            curDate = Calendar.current.date(byAdding: .month, value: 1, to: curDate)!
                        }
                    } else if $0.startLocation.x < $0.location.x - 20 {
                        curDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
                    }
                    self.offset = .zero
                }
        )
        .padding()
        .onChange(of: curDate) { _ in
        }
    }
}
