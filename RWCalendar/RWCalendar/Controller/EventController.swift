//
//  EventController.swift
//  RWCalendar
//
//  Created by Liu on 16.01.22.
//

import EventKit

class EventController: NSObject {
    typealias ControllerResponse = (_ result: Result<Bool, EventError>) -> Void

    var eventStore: EKEventStore!

    override init() {
        eventStore = EKEventStore()
    }

    /// Request access to the Calendar
    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: EKEntityType.event) { granted, error in
            completion(granted, error)
        }
    }

    /// Get Calendar auth status
    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: EKEntityType.event)
    }

    /// Check Calendar permissions auth status
    /// Try to add an event to the calendar if authorized
    func addEventToCalendar(event: Event, completion: @escaping ControllerResponse) {
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .authorized:
            addEvent(event: event, completion: { result in
                switch result {
                case .success:
                    completion(.success(true))
                case let .failure(error):
                    completion(.failure(error))
                }
            })
        case .notDetermined:
            // Auth is not determined
            // We should request access to the calendar
            requestAccess { accessGranted, error in
                if accessGranted {
                    self.addEvent(event: event, completion: { result in
                        switch result {
                        case .success:
                            completion(.success(true))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    })
                } else {
                    // Auth denied, we should display a popup
                    completion(.failure(.denied))
                }
            }
        case .denied:
            // Auth denied, we should display a popup
            completion(.failure(.denied))
        case .restricted:
            // Authrestricted, we should display a popup
            completion(.failure(.restricted))
        @unknown default:
            fatalError("Unknown Authentication Status.")
        }
    }

    /// Generate an event which will be then added to the calendar
    private func generateEvent(event: Event) -> EKEvent {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        newEvent.title = event.name
        newEvent.startDate = event.dateStart
        newEvent.endDate = event.dateEnd
        // Set default alarm minutes before event
        let alarm = EKAlarm(relativeOffset: TimeInterval(event.remindingOffset))
        newEvent.addAlarm(alarm)
        return newEvent
    }

    /// Try to save an event to the calendar
    private func addEvent(event: Event, completion: @escaping ControllerResponse) {
        let eventToAdd = generateEvent(event: event)
        if !eventAlreadyExists(event: eventToAdd) {
            do {
                try eventStore.save(eventToAdd, span: .thisEvent)
            } catch {
                // Error while trying to create event in calendar
                completion(.failure(.notAdded))
            }
            completion(.success(true))
        } else {
            completion(.failure(.alreadyExists))
        }
    }

    /// Check if the event was already added to the calendar
    private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
        let predicate = eventStore.predicateForEvents(
            withStart: eventToAdd.startDate,
            end: eventToAdd.endDate,
            calendars: nil
        )
        let existingEvents = eventStore.events(matching: predicate)

        let eventAlreadyExists = existingEvents.contains { event -> Bool in
            eventToAdd.title == event.title && event.startDate == eventToAdd.startDate && event.endDate == eventToAdd
                .endDate
        }
        return eventAlreadyExists
    }
}
