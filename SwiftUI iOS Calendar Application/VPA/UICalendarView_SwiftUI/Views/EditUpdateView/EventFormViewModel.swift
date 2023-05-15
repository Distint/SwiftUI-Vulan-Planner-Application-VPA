//Distint Howie - how4685@pennwest.edu

import Foundation

class EventFormViewModel: ObservableObject {
    
    // These properties represents the start,end date, note, and eventType of an event and is marked as @Published, which means any changes to it will trigger updates in SwiftUI views that depend on it.
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var note = ""
    
    // This property represents the type of event and is marked as @Published
    @Published var eventType: Event.EventType = .unspecified
    var id: String?
    var updating: Bool { id != nil }

    init() {
        // This is the default initializer for the class, and it is empty.
    }

    init(_ event: Event) {
        // This is a initializer that takes an event object of type Event as a parameter and initializes the view model's properties with the values from the event object.
        startDate = event.startDate
        endDate = event.endDate
        note = event.note
        eventType = event.eventType
        id = event.id
    }

    var incomplete: Bool {
        // This is a computed property that returns `true` if the `note` property is empty, indicating that the event is incomplete.
        note.isEmpty
    }
    
    //check if end date is earlier than the start date
    var comparisonResult: Bool {
        return endDate.compare(startDate) == .orderedAscending
       }
}
