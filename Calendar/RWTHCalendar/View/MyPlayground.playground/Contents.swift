import UIKit


let calendar = Calendar.current

extension Date{
    
    func getWeeks()-> [Date]{
        // the local calendar
        let calendar = Calendar.current
        
        
        let range = 1...7
        
        // getting the start Date
        
        var startDay = calendar.date(from: Calendar.current.dateComponents([.weekOfYear,.year], from: self))!
        startDay = calendar.date(byAdding: .hour, value: 2, to: startDay) ?? Date()
        //get date...
        //把Int转换成具体的日期
        
        return range.compactMap{weekday -> Date in
            return calendar.date(byAdding: .day, value: weekday - 1 , to: startDay) ?? Date()
        }
    }
}


let d = Date()
func extractDate()->[DateValue]{
    let days = d.getWeeks()
    
    let calendar = Calendar.current
    
    return days.compactMap{date->DateValue in
        let day = calendar.component(.day, from: date)
        let week = calendar.component(.weekOfYear, from: date)
        
        return DateValue(day: day, week: week, date: date)
    }
}


func getDate(currentWeek:Int)->[String]{
    
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY MMM"
    
    let calendar = Calendar.current
    var d = Date()
    d = calendar.date(byAdding: .weekOfYear, value: currentWeek, to: d)!
    
    var MonthAndYear = formatter.string(from: d)
    
    var date = MonthAndYear.components(separatedBy: " ")
    
    let weekOfYear = calendar.component(.weekOfYear, from: Date())
    date.append(String(weekOfYear))
    
    
    return date
}


//let calendar = Calendar.current
var h = Date()
h = calendar.date(byAdding: .weekOfYear, value: 20, to: d)!

print(calendar.component(.weekOfYear, from: h))
//var j = getDate(currentWeek: 20)
//print(j[2])


