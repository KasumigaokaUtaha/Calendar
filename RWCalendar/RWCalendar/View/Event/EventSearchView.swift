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
                    }
                    .fullScreenCover(isPresented: $displayEvent) {
                        EventEditView(event, defaultEventCalendar: event.calendar)
                    }
                }
                if store.state.searchResult.count == 0 && displayNoResult {
                    if searchText != "" {
                        Text("No Result for \(searchText)")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                store.send(.loadSearchResult(searchText))
                displayNoResult = true
                print(displayNoResult)
            }
            .navigationTitle("Search events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
        .onDisappear(perform: {
            store.send(.setSearchResult([]))
        })
    }
}
