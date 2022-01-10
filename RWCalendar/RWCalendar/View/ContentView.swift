//
//  ContentView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData

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
                    placement: .navigationBarTrailing
                ) {
                    NavigationLink(
                        destination: SettingView()
                            .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                            .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                    ) {
                        SettingButtonView()
                    }
                }
            }
            
            .background(Color(customizationData.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all))
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
