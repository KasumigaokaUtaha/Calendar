//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import CoreData
import Foundation

extension Event {
    
//    static var example: Event {
//        
//        let context = 
//        
//        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
//        fetchRequest.fetchLimit = 1
//        
//        let results = try? context.fetch(fetchRequest)
//        
//        return (results?.first!)!
//    }
    
}

extension Event {
    
    enum EventError: Error {
        case idNotIdentical
        case idNotFound
    }
}
