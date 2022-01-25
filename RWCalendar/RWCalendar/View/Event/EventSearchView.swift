//
//  EventSearchView.swift
//  RWCalendar
//
//  Created by Liu on 24.01.22.
//

import SwiftUI

struct EventSearchView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @Environment(\.presentationMode) var presentationMode

    @State private var searchText = ""
    @State private var displayEvent = false

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.searchResult, id: \.eventIdentifier) { event in
//                    NavigationLink(destination: EventEditView(
//                        event,
//                        defaultEventCalendar: event.calendar
//                    )) {
//                        Text(event.title)
//                    }
                    Button(event.title) {
                        displayEvent.toggle()
                    }
                    .fullScreenCover(isPresented: $displayEvent) {
                        EventEditView(event, defaultEventCalendar: event.calendar)
                    }
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                store.send(.loadSearchResult(searchText))
            }
            .navigationTitle("Search events")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear(perform: {
            store.send(.setSearchResult([]))
        })
    }
}

