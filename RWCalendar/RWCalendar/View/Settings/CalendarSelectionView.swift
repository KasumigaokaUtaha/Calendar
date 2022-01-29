//
//  CalendarSelectionView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/24.
//

import EventKit
import SwiftUI

struct CalendarSelectionView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>

    var calendars: [EKCalendar]

    var body: some View {
        var selections: [EKCalendar] = store.state.activatedCalendars
        var selectionNames: [String] = store.state.activatedCalendarNames
        List {
            ForEach(calendars, id: \.self) { calendar in
                MultipleSelectionRow(title: calendar.title, isSelected: selections.contains(calendar)) {
                    if selections.contains(calendar) {
                        selections.removeAll(where: { $0 == calendar })
                        selectionNames.removeAll(where: { $0 == calendar.title })
                    } else {
                        selections.append(calendar)
                        selectionNames.append(calendar.title)
                    }
                    store.send(.setActivatedCalendars(selections))
                    store.send(.setActivatedCalendarNames(selectionNames))
                }
            }
        }

        .navigationBarTitle(Text(NSLocalizedString("settings_calendars", comment: "Calendar Names")), displayMode: .inline)
    }
}

struct CalendarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSelectionView(calendars: [])
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
