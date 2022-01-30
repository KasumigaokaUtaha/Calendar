//
//  ThemeSelectionView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/24.
//

import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject var customizationData: CustomizationData

    var body: some View {
        ScrollView {
            ForEach(0 ..< ThemeManager.themes.count, id: \.self) { theme in
                Button(action: {
                    customizationData.savedThemeChoice = theme
                }) {
                    VStack {
                        HStack {
                            Text(ThemeManager.themes[theme].themeName)
                                .font(.title)
                            if theme == customizationData.savedThemeChoice {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(Color(ThemeManager.themes[theme].foregroundColor))
                            }
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Text(NSLocalizedString("themes_primary", comment: "Primary Color"))
                                .foregroundColor(Color(ThemeManager.themes[theme].primaryColor))
                            Spacer()
                            Text(NSLocalizedString("themes_secondary", comment: "Secondary Color"))
                                .foregroundColor(Color(ThemeManager.themes[theme].secondaryColor))
                            Spacer()
                        }
                    }
                    .padding()
                }
                .buttonStyle(FilledRoundedCornerButtonStyle(
                    minHeight: 80,
                    backgroundColor: Color(ThemeManager.themes[theme].backgroundColor),
                    foregroundColor: Color(ThemeManager.themes[theme].foregroundColor),
                    primaryColor: Color(ThemeManager.themes[theme].primaryColor)
                ))
                .disabled(theme == customizationData.savedThemeChoice)
            }
        }
        .padding()

        .navigationBarTitle(Text(NSLocalizedString("nav_theme", comment: "Navigation Theme")), displayMode: .inline)
    }
}

struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView()
            .environmentObject(CustomizationData())
            .preferredColorScheme(.light)
    }
}
