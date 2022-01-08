//
//  Task.swift
//  ElegantTaskApp
//
//  Created by Baichao Ye on 2022/1/1.
//

import SwiftUI

// task model

struct Task: Identifiable{
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}


struct TaskeMetaData: Identifiable{
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date = Date()
}


func getSampleDate(offset: Int)->Date{
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day,value: offset, to: Date())
    
    return date ?? Date()
}


var tasks: [TaskeMetaData] = [
    TaskeMetaData(task:[
    Task(title: "Talk to iJustine"),
    Task(title: "iphone 13")],taskDate: getSampleDate(offset: 0)),
    TaskeMetaData(task:[
    Task(title: "IOS"),
    Task(title: "1/19")],taskDate: getSampleDate(offset: 1))
]


