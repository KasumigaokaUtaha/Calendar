//
//  ContentView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                CompactCalendarYearView(size: proxy.size, columnsNumber: 3)
            }
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button("Today") {
                        store.send(.setScrollToToday(withAnimation: true))
                    }
                }
                ToolbarItem(
                    placement: .navigationBarLeading
                ) {
                    Button {
                        // Show context menu
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                
                ToolbarItem(
                    placement: .navigation
                ) {
                    NavigationLink("weekday", destination: WeekDays())
                }
                
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Calendar")
            
            
        }
        // LayoutConstraints error from NavigationView with navigationTitle
        // https://developer.apple.com/forums/thread/673113?answerId=687012022#687012022
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
