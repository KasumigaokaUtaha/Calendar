//
//  ContentView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 25.12.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @Environment(\.openURL) var openURL

    @State var showAlert = false

    var body: some View {
        if #available(iOS 15, *) {
            makeContent()
                .alert(store.state.alertTitle, isPresented: $showAlert) {
                    Button("Settings", action: makeOpenSettingsAction)
                    Button("OK", role: .cancel) {
                        store.send(.setShowAlert(false))
                    }
                } message: {
                    Text(store.state.alertMessage)
                }
                .onReceive(store.$state) { state in
                    if showAlert != state.showAlert {
                        showAlert = state.showAlert
                    }
                }
        } else {
            makeContent()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(store.state.alertTitle),
                        message: Text(store.state.alertMessage),
                        primaryButton: .default(Text("Settings")) {
                            makeOpenSettingsAction()
                        },
                        secondaryButton: .default(Text("OK")) {
                            store.send(.setShowAlert(false))
                        }
                    )
                }
                .onReceive(store.$state) { state in
                    if showAlert != state.showAlert {
                        showAlert = state.showAlert
                    }
                }
        }
    }

    @ViewBuilder func makeContent() -> some View {
        switch store.state.currentTab {
        case .year:
            ContainerView {
                CompactCalendarYearView()
            } makeNavigationBarButton: {
                Button {
                    store.send(.setScrollToToday(withAnimation: true))
                } label: {
                    Text("Today")
                }
            }
        case .month:
            ContainerView {
                // TODO: replace with actual view
                Text("Month")
                    .navigationTitle(String(format: "%d %d", store.state.selectedYear, store.state.selectedMonth))
            } makeNavigationBarButton: {
                Button {
                    store.send(.setScrollToToday(withAnimation: true))
                } label: {
                    Text("Today")
                }
            }
        case .week:
            ContainerView {
                // TODO: replace with actual view
                Text("Week")
            } makeNavigationBarButton: {
                Button {
                    store.send(.setScrollToToday(withAnimation: true))
                } label: {
                    Text("Today")
                }
            }
        case .day:
            ContainerView {
                // TODO: replace with actual view
                Text("day")
            } makeNavigationBarButton: {
                Button {
                    store.send(.setScrollToToday(withAnimation: true))
                } label: {
                    Text("Today")
                }
            }

        case .settings:
            ContainerView {
                // TODO: replace with actual view
                Text("settings")
            } makeNavigationBarButton: {
                Button {
                    store.send(.setScrollToToday(withAnimation: true))
                } label: {
                    Text("Today")
                }
            }

        case .onboarding:
            ContainerView {
                // TODO: replace with actual view
                Text("onboarding")
            } makeNavigationBarButton: {
                Button {
                    store.send(.open(.year))
                } label: {
                    Text("Done")
                }
            }
        case .event:
            ContainerView {
//                let event = Event(title: "", startDate: Date(), endDate: Date(), calendar: ,notes: "", remindingOffset: 60)
//                EventUpdateView(event)
            } makeNavigationBarButton: {
                Button {
                    //
                } label: {
                    Text("Done")
                }
            }
        }
    }

    func makeOpenSettingsAction() {
        guard
            let settingsURL = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsURL)
        else {
            return
        }

        openURL(settingsURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )

    static var previews: some View {
        ContentView()
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
