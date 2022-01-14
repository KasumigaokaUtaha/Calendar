//
//  WeekDaysPage.swift
//  RWTHCalendar
//
//  Created by Baichao Ye on 2022/1/2.
//

import SwiftUI

struct WeekDaysPage: View {
    @Binding var currentDate : Date
    @State var currentWeek: Int = 0
    @State var currentMonth: Int = 0
    var body: some View {
        VStack(spacing: 20){
            let weekDays:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            // display the year and the weeks number..
            HStack{
                VStack{
                    Button{
                        
                    } label: {
                        Text("Month")
                            .fontWeight(.heavy)
                        
                    }
                    HStack{
                        Button{
                            withAnimation{
                                currentWeek -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                        }
                        
                        Button{
                            withAnimation{
                                currentWeek += 1
                            }
                        }label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                        }
                    }
                }
                
                
                Spacer()
                
                HStack(spacing:10){
                    
                    //  display the year, month, weeks
                    VStack(spacing:5){
                        Text(getDate()[0])
                            .font(.title.bold())
                        
                        
                        
                        
                        Text("week: " + getDate()[2])
                            .font(.caption)
                        
                        
                    }
                    
                }
            }
            
            // display the month and the weekdays
            HStack(spacing:0){
                VStack{
                    
                    Text(getDate()[1])
                        .font(.callout)
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                ForEach(0...6,id: \.self){day in
                    VStack{
                        Text(weekDays[day])
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        //*******
                        Text(String(extractDate()[day].day))
                    }
                }
            }
            
            // complate the form
            ForEach(1...7,id:\.self){timeZone in
                
                HStack(spacing:0){
                    VStack(spacing: 10){
                        Text(String(timeZone))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        Text(getTimeSlot(timeZone))
                            .font(.subheadline)
                            .minimumScaleFactor(0.3)
                            .frame(maxWidth:.infinity,alignment: .trailing)
                        
                    }
                    ForEach(0...6,id:\.self){day in
                        VStack{
                            ForEach(weekDays,id: \.self){day in
                                Text(" ")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                
                            }
                        }.background(
                            Color("Pink")
                            
                        )
                    }
                    
                    
                }
            }
            
            
            
        }
    }
    //    let page = UIPageControl()
    
    
    
    
    
    
    
    
    //get the month, year, week
    func getDate()->[String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        
        let calendar = Calendar.current
        var d = Date()
        d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!
        
        var MonthAndYear = formatter.string(from: d)
        
        var date = MonthAndYear.components(separatedBy: " ")
        
        
        let weekOfYear = calendar.component(.weekOfYear, from: d)
        date.append(String(weekOfYear))
        
        
        return date
    }
    
    //get the timezone of the day
    func getTimeSlot(_ timeSlot: Int)-> String{
        let df = DateFormatter()
        let calendar = Calendar.current
        df.dateFormat = "yyyy-MM-DD HH mm zzz"
        let str = "2020-02-15 08 00 GMT"
        let orginalTime = df.date(from: str)
        
        var t_s = calendar.date(byAdding: .minute, value: (timeSlot-1) * 90 , to: orginalTime!)!
        var t_e = calendar.date(byAdding: .minute, value: timeSlot * 90 , to: orginalTime!)!
        let formatter = DateFormatter()
        formatter.dateFormat = "hh mm"
        let startTime =  formatter.string(from: t_s)
        let endTime = formatter.string(from: t_e)
        return "\(startTime)\n\(endTime)"
    }
    
    
    func extractDate()->[DateValue]{
        let days = self.currentDate.getWeeks(currentWeek: currentWeek)
        
        let calendar = Calendar.current
        
        
        return days.compactMap{date->DateValue in
            let day = calendar.component(.day, from: date)
            let week = calendar.component(.weekOfYear, from: date)
            
            return DateValue(day: day, week: week, date: date)
        }
        
        
    }
    
    
    
    
    
}

struct WeekDaysPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// extension Date to get the whole week
extension Date{
    
    func getWeeks(currentWeek:Int)-> [Date]{
        // the local calendar
        let calendar = Calendar.current
        
        
        let range = 1...7
        
        // getting the start Date
        
        var startDay = calendar.date(from: Calendar.current.dateComponents([.weekOfYear,.yearForWeekOfYear], from: self))!
        startDay = calendar.date(byAdding: .hour, value: 2, to: startDay) ?? Date()
        startDay = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: startDay)!
        //get date...
        //把Int转换成具体的日期
        
        return range.compactMap{weekday -> Date in
            return calendar.date(byAdding: .day, value: weekday - 1 , to: startDay) ?? Date()
        }
    }
}
