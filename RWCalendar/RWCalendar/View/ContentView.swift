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
        let testEvent = Event(
            name: "TEst",
            dateStart: Date(),
            dateEnd: Date(),
            description: "Test",
            remindingOffset: 60
        )
        EventUpdateView(testEvent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
