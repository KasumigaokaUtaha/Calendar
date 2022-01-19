//
//  ContentView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    
   
    //lazy var comp = components()
    @State var curDate : Date
    
   
    
    func components() -> DateComponents{
        var comp = DateComponents()
        comp.month = store.state.selectedMonth
        comp.year = store.state.selectedYear
        return comp
    }
    
    init(curDate: Date){
        self.curDate = Calendar.current.date(from: components())!
    }
    
    var body: some View {
        
        
        switch store.state.currentTab {
        case .year:
//            GeometryReader { proxy in
//                CompactCalendarYearView(size: proxy.size)
//            }
            ContainerView {
                CompactCalendarYearView()
            }
        case .month:
            
            ContainerView {
                // TODO: replace with actual view
                //Text("Month")
                
                TrueMonthView(curDate: $curDate)
                    .navigationTitle(String(format: "%d %d", store.state.selectedYear, store.state.selectedMonth))
            }
        case .week:
            ContainerView {
                // TODO: replace with actual view
                Text("Week")
            }
        case .day:
            ContainerView {
                // TODO: replace with actual view
                Text("day")
            }
        case .settings:
            ContainerView {
                // TODO: replace with actual view
                Text("settings")
            }
        case .onboarding:
            ContainerView {
                // TODO: replace with actual view
                Text("onboarding")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    
    
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    
    @State var curDate = Date()
    static var previews: some View {

        
        //var comp = components()
        
        ContentView(curDate: Date())
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
