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
    @State private var displayNoResult = false
    @Binding private var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.searchResult, id: \.eventIdentifier) { event in
                    Button(event.title) {
                        displayEvent.toggle()
                        store.send(.setSelectedEvent(event))
                    }
                    .fullScreenCover(isPresented: $displayEvent) {
                        EventDisplayView()
                    }
                }
                if store.state.searchResult.count == 0, displayNoResult {
                    if searchText != "" {
                        Text(NSLocalizedString("noResult", comment: "No result for:") + "\(searchText)")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                store.send(.loadSearchResult(searchText))
                displayNoResult = true
            }
            .navigationTitle(Text(NSLocalizedString("nav_search", comment:"Search events")))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text(NSLocalizedString("back", comment: "Back"))
                    }
                }
            }
        }
        .onDisappear(perform: {
            store.send(.setSearchResult([]))
        })
    }
}
