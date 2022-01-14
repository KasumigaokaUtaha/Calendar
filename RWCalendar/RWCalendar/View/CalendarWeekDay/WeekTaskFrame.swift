//
//  WeekTaskFrame.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI



struct WeekTaskFrame: View {
    @Binding var currentWeek :Int
    
    
    var body: some View {
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
                        ForEach(0...6,id: \.self){day in
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
}

struct WeekTaskFrame_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
