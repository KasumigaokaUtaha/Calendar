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
    @Binding var curDate : Date
    @State private var offset: CGSize = .zero
    @State var curMonth = 0
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    
    
     
    //@State var curDate =Calendar.current.date(from: components())!
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
            ForEach(RWCalendar.getDate(value: curMonth)) { value in

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
            curDate = RWCalendar.getCurMonth(value: curMonth)
        }
    }
    
    
    
    

}

