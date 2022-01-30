//
//  SettingView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/22.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var customizationData: CustomizationData

    @State private var iconName = NSLocalizedString("icon_default", comment:"Default Icon")

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("settings_sectionCalendarSettings", comment: "Section: Calendar Settings"))) {
                NavigationLink(
                    destination: SourceSelectionView()
                        .font(.custom(
                            customizationData.savedFontStyle,
                            size: CGFloat(customizationData.savedFontSize)
                        ))
                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                ) {
                    Text(NSLocalizedString("settings_displayedCalendars", comment: "Displayed Calendars"))
                }
            }

            Section(header: Text(NSLocalizedString("settings_sectionCustomization", comment: "Section: Customization"))) {
                Picker(selection: customizationData.$savedFontSize, label: Text(NSLocalizedString("settings_fontSize", comment: "Font Size")), content: {
                    Text(NSLocalizedString("settings_extraSmall", comment: "Extra Small"))
                        .tag(10)
                        .font(.custom(customizationData.savedFontStyle, size: 10, relativeTo: .body))
                    Text(NSLocalizedString("settings_small", comment: "Small"))
                        .tag(13)
                        .font(.custom(customizationData.savedFontStyle, size: 13, relativeTo: .body))
                    Text(NSLocalizedString("settings_medium", comment: "Medium"))
                        .tag(17)
                        .font(.custom(customizationData.savedFontStyle, size: 17, relativeTo: .body))
                    Text(NSLocalizedString("settings_large", comment: "Large"))
                        .tag(21)
                        .font(.custom(customizationData.savedFontStyle, size: 21, relativeTo: .body))
                    Text(NSLocalizedString("settings_extraLarge", comment: "Extra Large"))
                        .tag(24)
                        .font(.custom(customizationData.savedFontStyle, size: 24, relativeTo: .body))
                })

                Picker(selection: customizationData.$savedFontStyle, label: Text(NSLocalizedString("settings_fontStyle", comment: "Font Style")), content: {
                    Text("Times New Roman")
                        .tag("Times New Roman")
                        .font(.custom("Times New Roman", size: CGFloat(customizationData.savedFontSize)))
                    Text("San Francisco")
                        .tag("San Francisco")
                        .font(.custom("San Francisco", size: CGFloat(customizationData.savedFontSize)))
                    Text("Avenir Next")
                        .tag("Avenir Next")
                        .font(.custom("Avenir Next", size: CGFloat(customizationData.savedFontSize)))
                })

                NavigationLink(
                    destination: ThemeSelectionView()
                ) {
                    Text(NSLocalizedString("settings_theme", comment: "Theme"))
                    Spacer()
                    Text(customizationData.selectedTheme.themeName)
                }

                NavigationLink(
                    destination: IconSelectionView(iconName: $iconName)
                ) {
                    Text(NSLocalizedString("settings_appIcon", comment: "App Icon"))
                    Spacer()
                    Text(iconName)
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().preferredColorScheme(.light)
            .environmentObject(CustomizationData())
    }
}
