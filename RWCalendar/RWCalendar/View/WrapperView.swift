//
//  WrapperView.swift
//  RWCalendar
//
//  Created by 邱昕昊 on 2022/1/10.
//

import SwiftUI

struct WrapperView: View {
    @EnvironmentObject var customizationData: CustomizationData
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ContentView()
            .colorScheme(colorScheme)
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
    }
}
