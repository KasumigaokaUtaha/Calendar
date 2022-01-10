//
//  WrapperView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/10.
//

import SwiftUI

struct WrapperView: View {
    @EnvironmentObject var customizationData: CustomizationData
    
    var body: some View {
        ContentView()
            .preferredColorScheme(customizationData.savedDarkMode ? .dark : .light)
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
    }
}
