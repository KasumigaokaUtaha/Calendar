//
//  EventDisplayView.swift
//  RWCalendar
//
//  Created by Liu on 26.01.22.
//

import SwiftUI

struct EventDisplayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    @State var displayEditView = false

    let dateFormatter = DateFormatter()
    var event: Event? {
        guard let selectedEvent = store.state.selectedEvent else {
            return nil
        }
        return selectedEvent
    }

    init() {
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if self.event != nil {
                    Text(event!.title)
                        .bold()
                        .font(.title2)
                    Divider()
                    HStack(alignment: .center) {
                        Text(NSLocalizedString("from", comment: "From"))
                        Spacer()
                        Text(dateFormatter.string(from: event!.startDate))
                    }
                    HStack(alignment: .center) {
                        Text(NSLocalizedString("to", comment: "To"))
                        Spacer()
                        Text(dateFormatter.string(from: event!.endDate))
                    }

                    if self.event!.notes != nil {
                        Divider()
                        Text(NSLocalizedString("notes", comment: "Notes")).bold()
                        Text(event!.notes!)
                    }
                    // TODO: fix potential bugs
                    if self.event!.url != nil, self.event!.url != "" {
                        Divider()
                        Text(NSLocalizedString("url", comment: "URL")).bold()
                        Link(event!.url!, destination: URL(string: event!.url!)!)
                    }
                    Spacer()
                } else {
                    Text(NSLocalizedString("noEventSelected", comment: "No event selected"))
                        .foregroundColor(Color.gray)
                }
            }
            .toolbar(content: makeToolbar)
            .sheet(isPresented: $displayEditView) {
                EventEditView(
                    self.event,
                    defaultEventCalendar: self.event?.calendar ?? store.state.defaultEventCalendar
                )
            }
            .padding(.horizontal, 25)
            .navigationTitle(NSLocalizedString("nav_details", comment: "Event Details"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    func makeToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("back", comment: "Back")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if self.event != nil {
                    Button {
                        displayEditView.toggle()
                    } label: {
                        Text(NSLocalizedString("edit", comment: "Edit"))
                    }
                }
            }
        }
    }
}
