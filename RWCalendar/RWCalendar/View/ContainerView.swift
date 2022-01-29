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
    @EnvironmentObject var customizationData: CustomizationData

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
}
