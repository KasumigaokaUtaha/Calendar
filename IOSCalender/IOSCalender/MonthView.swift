//
//  MonthView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//

import SwiftUI
import Foundation


let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri", "Sat"]

struct MonthView: View {
    
    //@Binding var curDate: Date
    
    @State var curMonth: Int = 0
   
    var body: some View {

        
                VStack{
                    
                    VStack{
                        
                        HStack(){
                            Button( "Today"){
                                curMonth = 0
                            }
                            // years and months
                            VStack(alignment: .leading , spacing: 5){
                                Text("2022")
                                    .fontWeight(.bold)
                            
                                Text("January")
                                    .fontWeight(.bold)
                            
                            }
                            
                        }
                        
                    }
                    .padding()
    
                    //Spacer()
                    HStack(spacing: 30){
                        ForEach(days, id:\.self){day in
                            Text(day)
                                .font(.body)
                               
                        }
                    }
                    
                    ScrollView(.vertical){
                        GeometryReader{ proxy in
                            Color
                                .clear
                            /*
                                .preference(key: RefreshPreferenceTypes.RefreshPreferenceKey.self,
                                            value: [RefreshPreferenceTypes.RefreshPreferenceData(viewType: .movingPositionView, bounds: proxy.frame(in: .global))])
                             */

                               

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 25){
                                
                                ForEach(getDate()){ value in
                                    
                                  
                                    VStack{
                                        if value.day != 0 {
                                            Text("\(value.day)")
                                                .foregroundColor(isToday(date: value.date) ? .blue : .none)
                                            

                                            
                                        }
                                     
                                    }
                                
                                }
                            }
                            
                        }
                        .frame(height: 0)
                    
                    Spacer()
                    }
                }
  
        }
       
        
    }
    
    


struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date{
    
    func getMonthDate()->[Date]{
       // let calender = Calendar.current
        
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        
        let starter = Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        
        return range.compactMap{ day -> Date in
            return Calendar.current.date(byAdding: .day, value: day-1 , to: starter)!
            
        }
    }
}

extension MonthView{
    //helping functions
    
    func getCurMonth()->Date{
        
        return Calendar.current.date(byAdding: .month, value: self.curMonth, to: Date())!

    }
    
    
    func isToday(date: Date)->Bool{
 
        return Calendar.current.isDateInToday(date)
    }

    
    func getDate()->[DateData]{
        

        var days = getCurMonth().getMonthDate().compactMap { date -> DateData in
     
            let day = Calendar.current.component(.day, from: date)
            
            return DateData(day: day, date: date)
        }
        
        let firstWeek = Calendar.current.component(.weekday, from: days.first!.date)
        
        for _ in 0..<firstWeek - 1{
            //offset: set extra dates as 0
            days.insert(DateData(day: 0, date: Date()), at: 0)
        }
        
        return days
    }

}
/*
struct RefreshPreferenceTypes {
    enum ViewType: Int {
        case fixedPositionView
        case movingPositionView
    }
    
    struct RefreshPreferenceData: Equatable {
        let viewType: ViewType
        let bounds: CGRect
    }
    
    struct RefreshPreferenceKey: PreferenceKey {
        static var defaultValue: [RefreshPreferenceData] = []
        
        static func reduce(value: inout [RefreshPreferenceData],
                           nextValue: () -> [RefreshPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }
}
*/
