//
//  Event.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 30.12.21.
//

import CoreData
import Foundation

extension Event {
    
    static var example: Event {
        
        let context = DataController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
}
