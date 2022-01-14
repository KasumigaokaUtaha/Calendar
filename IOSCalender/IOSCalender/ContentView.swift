//
//  ContentView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//

import SwiftUI

struct ContentView: View {
    @State var curDate: Date = Date()
    var body: some View {
        MonthView(curDate: $curDate)
        //RefreshScrollView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
