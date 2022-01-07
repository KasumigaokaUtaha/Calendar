//
//  DataController.swift
//  RWCalendar
//
//  Created by Liu on 06.01.22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    static var preview: DataController = {
        
        let dataController = DataController(inMemory: true)
        
        let mockName = "test name"
        let startDate = Date()
        let endDate = Date()
        
        dataController.saveEvent(named: mockName, startFrom: startDate, endAt: endDate)
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            print("Failed to save test event: \(error)")
        }
        
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RWCalendar")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores {
            description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

extension DataController {
    func saveEvent(named name: String, startFrom startDate: Date, endAt endDate: Date) {
        let event = Event(context: container.viewContext)
        
        event.id = UUID()
        event.name = name
        event.startDate = startDate
        event.endDate = endDate
        
        do {
            try container.viewContext.save()
            
        } catch {
            print("Failed to save event: \(error)")
        }
    }
}
