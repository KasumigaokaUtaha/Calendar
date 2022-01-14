//
//  MonthView.swift
//  IOSCalender
//
//  Created by Liangkun He on 04.01.22.
//

import SwiftUI
import Foundation


let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri", "Sat"]
let dateArray = Array(repeating: GridItem(.flexible()), count: 7)

struct TrueMonthView: View {
    
    @Binding var curDate: Date
    @State private var offset: CGFloat = 0
    @State var curMonth: Int = 0
   
    var body: some View {

        
                VStack{
                    
                    TitleView
    
                    //Spacer()
                    HStack(spacing: 30){
                        ForEach(days, id:\.self){day in
                            Text(day)
                                .font(.body)
                               
                        }
                    }
                   
                    
                    ScrollView(.vertical){
                        
                      
                        DateView
                    
                    Spacer()
                    }
                    /*
                    .onPreferenceChange(OffsetPreferenceKey.self, perform: {
                        value in
                        offset = value
                        
                        if offset >= 15.0 {
                                    curMonth += 1
                        }else if offset <= -15.0 {
                                    curMonth -= 1
                         }
                        
                        //curDate = getCurMonth()
                        
                    })
                         */
                }
        
                
         
        }
       
        
    }
    
    
struct MonthHome: View {
    @State var curDate:Date = Date()

    var body: some View {
       TrueMonthView(curDate: $curDate)
        
        
        
        
        
    }
}

struct TrueMonthView_Previews: PreviewProvider {
   
    static var previews: some View {
       // @State var curdate: Date = Date()
       MonthHome()
    }
}

extension Date{
    
    func getMonthDate()->[Date]{
        
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        
        let starter = Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        
        return range.compactMap{ day -> Date in
            return Calendar.current.date(byAdding: .day, value: day-1 , to: starter)!
            
        }
    }
}

extension TrueMonthView{
    //helping functions
    
    var TitleView: some View{
        VStack{
            
            HStack(){
                Button{
                    curMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button( "Today"){
                    curMonth = 0
                }
                // years and months
            
                    
                
                VStack(alignment: .leading , spacing: 5){
                    Text(dateToString()[1])
                        .fontWeight(.bold)
                
                    Text(dateToString()[0])
                        .fontWeight(.bold)
                
                }
                Button{
                    curMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                }
                
            }
            
        }
        .padding()
    }
    
    var DateView: some View{
        LazyVGrid(columns: dateArray, spacing: 25){
            
            ForEach(getDate()){ value in
                
              
                VStack{
                    if value.day != 0 {
                        Text("\(value.day)")
                            .foregroundColor(isToday(date: value.date) ? .blue : .none)

                    }
                 
                }
            
            }
        
        
        }
        .padding()
        .onChange(of: curMonth){ value in
            curDate = getCurMonth()
        }
    }
    
    func dateToString()->[String]{
        let month = Calendar.current.component(.month, from: curDate) - 1
        let year = Calendar.current.component(.year, from: curDate)
        
        return ["\(year)", Calendar.current.monthSymbols[month]]
    }
    
    struct OffsetPreferenceKey: PreferenceKey{
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
        
    }
    
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
