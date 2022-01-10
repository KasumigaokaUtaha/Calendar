//
//  SettingButtonView.swift
//  Calendar
//
//  Created by 邱昕昊 on 2021/12/23.
//

import SwiftUI

struct SettingButtonView: View {
    @EnvironmentObject var customizationData: CustomizationData
    
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "gear")
                .frame(width: geometry.size.width, height: geometry.size.height)
                .foregroundColor(Color(customizationData.selectedTheme.foregroundColor))
        }
    }
}

struct SettingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingButtonView()
            .environmentObject(CustomizationData())
    }
}
