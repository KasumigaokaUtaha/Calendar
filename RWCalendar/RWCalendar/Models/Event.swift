//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import CoreData
import Foundation

//struct Event {
//    var name: String
//    var startDate: Date
//    var endDate: Date
//}
// 1
//class DataController: ObservableObject {
//    let container = NSPersistentContainer(name: "RWCalendar")
//
//    init() {
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Core Data failed to load: \(error.localizedDescription)")
//            }
//        }
//    }
//}
extension Event {
    
    static var example: Event {
        
        let context = DataController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
}
