//
//  ContainerView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 17.01.22.
//

import SwiftUI

/// A container view that consists of a navigation view and a custom content view
struct ContainerView<Content, T>: View where Content: View, T: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var content: () -> Content
    var makeNavigationBarButton: () -> T

    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder makeNavigationBarButton: @escaping () -> T) {
        self.content = content
        self.makeNavigationBarButton = makeNavigationBarButton
    }

    var body: some View {
        NavigationView {
            content()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        makeMenu()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        makeNavigationBarButton()
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
}
