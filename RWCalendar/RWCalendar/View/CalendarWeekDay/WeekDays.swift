//
//  WeekDays.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct WeekDays: View {
    @State var currentDate : Date = Date()
    @State var currentWeek: Int = 0
    @State var currentMonth: Int = 0
    @State private var offset = CGSize.zero
    var body: some View {
        ScrollView{
            let weekDays:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            // display the year and the weeks number..
            HStack(alignment:.top){
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
            
            
            ZStack{
                
                WeekTaskFrame(currentWeek: $currentWeek)
                    .background(Color.red)
                    .animation(.default)
                    .offset(x:offset.width * 3)
                    .gesture(
                        DragGesture()
                            .onChanged{
                                self.offset = $0.translation
                            }
                            .onEnded{ _ in
                                if offset.width > 100 {
                                    self.currentWeek += 1
                                }else if offset.width < -100{
                                    self.currentWeek -= 1
                                }
                            }
                    ).background(Color.red
                    )
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
    
    
    func extractDate()->[DayData]{
        let days = self.currentDate.getWeeks(currentWeek: currentWeek)
        
        let calendar = Calendar.current
        
        
        return days.compactMap{date->DayData in
            let day = calendar.component(.day, from: date)
            let week = calendar.component(.weekOfYear, from: date)
            
            return DayData(day: day,  date: date,weekday: Weekday(week,calendar: Calendar.current) ?? Weekday.monday)
        }
    }
    
    
    
    
    
}




