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

    @Published private(set) var events: [Event] = []

//    static var preview: DataController = {
//        let dataController = DataController(inMemory: true)
//
//        let mockName = "test name"
//        let startDate = Date()
//        let endDate = Date()
//
//        let newEvent = EventDTO(name: mockName, startDate: startDate, endDate: endDate)
//
//        dataController.saveEvent(newEvent: newEvent)
//
//        do {
//            try dataController.container.viewContext.save()
//        } catch {
//            print("Failed to save test event: \(error)")
//        }
//
//        return dataController
//    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RWCalendar")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores {
            _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                self.events = self.getAllEvents()
            }
        }
    }
}

extension DataController {
    func saveEvent(newEvent _: EventDTO) {
        let event = Event(context: container.viewContext)

        event.id = UUID()
        event.name = event.name
        event.startDate = event.startDate
        event.endDate = event.endDate

        do {
            try container.viewContext.save()

        } catch {
            print("Failed to save event: \(error)")
        }
    }
}

extension DataController {
    func updateEvent(updatedEvent event: EventDTO, id: UUID) throws -> Event {
        let fetchRequest: NSFetchRequest<Event>

        fetchRequest = Event.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id like %@", id as CVarArg)

        let context = container.viewContext

        let result = try context.fetch(fetchRequest)
        if let eventToUpdate = result.first {
            eventToUpdate.setValue(event.name, forKey: "name")
            eventToUpdate.setValue(event.startDate, forKey: "startDate")
            eventToUpdate.setValue(event.endDate, forKey: "endDate")
            try context.save()
        }
        print("Event updated.")
        
        let newEvents = try context.fetch(fetchRequest)
        if newEvents.count > 1 {
            throw Event.EventError.idNotIdentical
        }
        
        if let newEvent = newEvents.first {
            return newEvent
        } else {
            throw Event.EventError.idNotFound
        }
    }
}

extension DataController {
    func getAllEvents() -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        do {
            return try container.viewContext.fetch(fetchRequest)

        } catch {
            print("Failed to fetch events \(error)")
        }

        return []
    }
}
