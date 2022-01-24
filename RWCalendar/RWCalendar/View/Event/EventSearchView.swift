//
//  EventSearchView.swift
//  RWCalendar
//
//  Created by Liu on 24.01.22.
//

import SwiftUI

struct EventSearchView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
                    List {
                        ForEach(searchResults, id: \.eventIdentifier) { event in
                            NavigationLink(destination: EventEditView(event, defaultEventCalendar: store.state.defaultEventCalendar)) {
                                Text(event.title)
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .navigationTitle("Events")
                }
    }
    
    var searchResults: [Event] {
        if searchText.isEmpty {
            return []
        } else {
            store.send(.loadSearchResult(searchText))
            return store.state.searchResult
        }
    }
}

struct EventSearchView_Previews: PreviewProvider {
    static var previews: some View {
        EventSearchView()
    }
}
