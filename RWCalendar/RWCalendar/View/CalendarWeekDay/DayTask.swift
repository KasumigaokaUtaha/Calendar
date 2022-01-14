//
//  DayTask.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct DayTask: View {
    @Binding var task :String
    @Binding var minWidth: CGFloat
    @Binding var maxWidth:CGFloat
    @Binding var minHeight :CGFloat
    @Binding var maxHeight:CGFloat
    
   
    
    var body: some View {
        
        Text("\(task)")
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight:minWidth, maxHeight: maxHeight)
    }
}

struct DayTask_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
