//
//  IconSelectionView.swift
//  Calendar
//
//  Created by 邱昕昊 on 2022/1/2.
//

import SwiftUI

struct IconSelectionView: View {
    @EnvironmentObject var customizationData: CustomizationData

    @Binding var iconName: String

    let iconNameList: [String] = ["Default", "Lila", "Blue"]

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top, spacing: 30) {
                ForEach(0 ..< iconNameList.count, id: \.self) { idx in
                    Button(action: {
                        customizationData.savedAppIcon = iconNameList[idx]
                        iconName = iconNameList[idx]
                    }) {
                        VStack {
                            Image(iconNameList[idx] + "Preview")
                                .cornerRadius(20)
                            HStack {
                                Text(iconNameList[idx])
                                if customizationData.savedAppIcon == iconNameList[idx] {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
                                }
                            }
                        }
                    }
                    .buttonStyle(FilledRoundedCornerButtonStyle(
                        maxWidth: 100,
                        maxHeight: 100,
                        backgroundColor: Color(.lightGray),
                        foregroundColor: Color(customizationData.selectedTheme.foregroundColor),
                        primaryColor: Color(customizationData.selectedTheme.primaryColor)
                    ))
                    .disabled(customizationData.savedAppIcon == iconNameList[idx])
                }
            }
            .padding()

            Spacer()

                .navigationBarTitle(Text("App Icons"), displayMode: .inline)
        }
        .padding()
    }
}

struct IconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectionView(iconName: .constant("Default"))
            .environmentObject(CustomizationData())
    }
}
