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

            MonthHome(curDate: Calendar.current.date(from: components())!)

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
            CalendarDayView()

        case .settings:

            ContainerView {
                Text("setting")

                SettingView()
                    .navigationTitle(Text("Settings"))
                    .background(Color(customizationData.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all))
                    .font(.custom(customizationData.savedFontStyle, size: CGFloat(customizationData.savedFontSize)))
                    .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))

            } makeNavigationBarButton: {
                Text("")
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

extension ContentView {
    // get the components of the selected date
    func components() -> DateComponents {
        var comp = DateComponents()
        comp.month = store.state.selectedMonth
        comp.year = store.state.selectedYear
        return comp
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
                store.send(.requestAccess(to: .event))
                store.send(.loadDefaultCalendar(for: .event))
                store.send(.setScrollToToday(withAnimation: false))
                store.send(.loadYearDataRange(
                    base: store.state.currentYear,
                    range: -rangeStart ... 3
                ))
            }
    }
}
