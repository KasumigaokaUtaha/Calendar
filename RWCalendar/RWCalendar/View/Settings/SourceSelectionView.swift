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
        let sources = store.state.sourcesAndCalendars.map(\.key)
        let calendars = store.state.sourcesAndCalendars.map(\.value)
        List {
            ForEach(sources.indices) { idx in
                NavigationLink(
                    destination: CalendarSelectionView(calendars: calendars[idx])
                        .font(.custom(
                            customizationData.savedFontStyle,
                            size: CGFloat(customizationData.savedFontSize)
                        ))
                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                ) {
                    Text(sources[idx].title)
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
