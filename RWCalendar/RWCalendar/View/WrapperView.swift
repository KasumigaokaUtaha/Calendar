//
//  WrapperView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/10.
//

import SwiftUI

struct WrapperView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ContentView()
            .colorScheme(colorScheme)
            .onAppear {
                store.send(.loadSourcesAndCalendars)
                store.send(.loadAppStorageProperties)
                store.send(.loadStoredCalendars)
            }
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
    }
}
