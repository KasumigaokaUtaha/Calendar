//
//  SourceSelectionView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/23.
//

import EventKit
import SwiftUI

struct SourceSelectionView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData

    var body: some View {
        let sourcesAndCalendars = store.state.sourcesAndCalendars.sorted { $0.key.title < $1.key.title}
        List {
            ForEach(sourcesAndCalendars, id: \.key) { source, calendar in
                NavigationLink(
                    destination: CalendarSelectionView(calendars: calendar.sorted { $0.title < $1.title })
                        .font(.custom(
                            customizationData.savedFontStyle,
                            size: CGFloat(customizationData.savedFontSize)
                        ))
                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                ) {
                    Text(source.title)
                }
            }
        }

        .navigationBarTitle(Text("Sources"), displayMode: .inline)
    }
}

struct SourceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SourceSelectionView()
    }
}
