//
//  WeekDaysHome.swift
//  RWTHCalendar
//
//  Created by Baichao Ye on 2022/1/1.
//

import SwiftUI

struct WeekDaysHome: View {
    @State var currentDate:Date = Date()
//    @State var currentWeek: Int = 0
    var body: some View {
        TabView{
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing: 20){
                    // Custom Date Picker
                    WeekDaysPage(currentDate: $currentDate)
                }
            }
            Text("aaa")
        }.tabViewStyle(.page)
        
        
        
        
        
        
    }
}

struct WeekDaysHome_Previews: PreviewProvider {
    static var previews: some View {
        WeekDaysHome()
    }
}
