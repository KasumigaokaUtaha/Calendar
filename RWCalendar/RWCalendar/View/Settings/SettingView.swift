//
//  SettingView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2021/12/22.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var customizationData: CustomizationData

    @State private var iconName = "Default"

    // Change background color for setting view
//    init() {
//        UITableView.appearance().backgroundColor = .clear
//    }

    var body: some View {
        Form {
            Section(header: Text("Customization")) {
                Picker(selection: customizationData.$savedFontSize, label: Text("Font Size"), content: {
                    Text("Extra Small")
                        .tag(10)
                        .font(.custom(customizationData.savedFontStyle, size: 10, relativeTo: .body))
                    Text("Small")
                        .tag(13)
                        .font(.custom(customizationData.savedFontStyle, size: 13, relativeTo: .body))
                    Text("Medium")
                        .tag(17)
                        .font(.custom(customizationData.savedFontStyle, size: 17, relativeTo: .body))
                    Text("Large")
                        .tag(21)
                        .font(.custom(customizationData.savedFontStyle, size: 21, relativeTo: .body))
                    Text("Extra Large")
                        .tag(24)
                        .font(.custom(customizationData.savedFontStyle, size: 24, relativeTo: .body))
                })

                Picker(selection: customizationData.$savedFontStyle, label: Text("Font Style"), content: {
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
                    Text("Theme")
                    Spacer()
                    Text(customizationData.selectedTheme.themeName)
                }

                NavigationLink(
                    destination: IconSelectionView(iconName: $iconName)
                ) {
                    Text("App Icon")
                    Spacer()
                    Text(iconName)
                }
            }
        }
//        .background(Color(customizationData.selectedTheme.backgroundColor))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().preferredColorScheme(.light)
            .environmentObject(CustomizationData())
    }
}
