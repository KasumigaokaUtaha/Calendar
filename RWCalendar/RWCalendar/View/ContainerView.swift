//
//  ContainerView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 17.01.22.
//

import SwiftUI

/// A container view that consists of a navigation view and a custom content view
struct ContainerView<Content>: View where Content: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationView {
            content()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        makeMenu()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        makeButton()
                    }
                }
        }
        .navigationViewStyle(.stack)
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

    func makeButton() -> some View {
        Button {
            store.send(.setScrollToToday(withAnimation: true))
        } label: {
            Text("Today")
        }
    }
}
