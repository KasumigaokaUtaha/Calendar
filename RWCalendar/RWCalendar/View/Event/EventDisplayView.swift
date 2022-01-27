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
                        Text("From")
                        Spacer()
                        Text(dateFormatter.string(from: event!.startDate))
                    }
                    HStack(alignment: .center) {
                        Text("To")
                        Spacer()
                        Text(dateFormatter.string(from: event!.endDate))
                    }

                    if self.event!.notes != nil {
                        Divider()
                        Text("Notes").bold()
                        Text(event!.notes!)
                    }
                    if self.event!.url != nil && self.event!.url != "" {
                        Divider()
                        Text("URL").bold()
                        Link(event!.url!, destination: URL(string: event!.url!)!)
                    }
                    Spacer()
                }
            }
            .toolbar(content: makeToolbar)
            .padding(.horizontal, 25)
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    func makeToolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: {
                        EventEditView(
                            self.event,
                            defaultEventCalendar: self.event?.calendar ?? store.state.defaultEventCalendar
                        )
                    },
                    label: { Text("Edit") }
                )
            }
        }
    }
}

// struct EventDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDisplayView()
//    }
// }
