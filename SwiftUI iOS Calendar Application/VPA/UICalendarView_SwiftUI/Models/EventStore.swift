//Distint Howie - how4685@pennwest.edu

import Foundation
import SwiftUI

@MainActor
class EventStore: ObservableObject {
    @Published var events = [Event]()  // Published property to store events
    @Published var preview: Bool     // Published property to indicate whether to use preview data
    @Published var changedEvent: Event?   // Published property to store the most recently changed event
    @Published var movedEvent: Event?     // Published property to store the most recently updated event
    @EnvironmentObject var lnManager: LocalNotificationManager // Accesses the shared LocalNotificationManager object from the environment
    
    init(preview: Bool = false) {
        self.preview = preview
        fetchEvents()   // Fetch events during initialization
    }
    
    func fetchEvents() {
        // Load events from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "events"),
           let decodedEvents = try? JSONDecoder().decode([Event].self, from: data) {
            events = decodedEvents
        }
    }
    
    
    func delete(_ event: Event) {
        if let index = events.firstIndex(where: {$0.id == event.id}) {
            changedEvent = events.remove(at: index)   // Remove event from events array and update changedEvent
            // Remove the associated notification
            /*if let notificationIdentifier = changedEvent?.id {
                lnManager.removeRequest(withIdentifier: notificationIdentifier)
            }*/
            saveEvents()   // Save events after deletion
            
            // Call deleteEventFromDatabase function to delete event from the MySQL database
            /*if let eventID = Int(event.id) { // Convert eventID to Int
                deleteEventFromDatabase(eventID: eventID)
            } else {
                print("Error: Invalid eventID")
            }*/
        }
    }
    
    func add(_ event: Event) {
        events.append(event)        // Append event to events array
        changedEvent = event       // Update changedEvent
        saveEvents()   // Save events after addition
    }
    
    func update(_ event: Event) {
        if let index = events.firstIndex(where: {$0.id == event.id}) {
            movedEvent = events[index]   // Store original event before update in movedEvent
            
            // Update properties of the event in events array
            events[index].startDate = event.startDate
            events[index].endDate = event.endDate
            events[index].note = event.note
            events[index].eventType = event.eventType
            changedEvent = event       // Update changedEvent
            saveEvents()   // Save events after update
        }
    }
    
    func saveEvents() {
        // Encode events array to data and save to UserDefaults
        if let encodedEvents = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encodedEvents, forKey: "events")
            if let event = changedEvent {
                insertEventToDatabase(event: event) // Pass the changedEvent instance to the function
            }
        }
    }
    
    func insertEventToDatabase(event: Event) {
        //let url = URL(string: "http://localhost/schedule/event.php")! // url for localhost testing
        let url = URL(string: "http://10.2.84.46/php_files/event.php")! //server url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(event)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                }
            }
            task.resume()
        } catch {
            print("Error encoding event data: \(error.localizedDescription)")
        }
    }
    
    func deleteEventFromDatabase(eventID: Int) {
        //let url = URL(string: "http://localhost/schedule/deleteEvent.php")!
        let url = URL(string: "http://10.2.84.46/php_files/event.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["eventID": eventID] // Pass the eventID as a parameter to be sent to the PHP script
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                }
            }
            task.resume()
        } catch {
            print("Error encoding eventID data: \(error.localizedDescription)")
        }
    }
}

