//Distint Howie - how4685@pennwest.edu

import Foundation
import Firebase

struct Event: Identifiable, Codable{
    enum CodingKeys: String, CodingKey {
        case eventType
        case startDate
        case endDate
        case note
        case id
    }
    
    // This is the initializer method for decoding an instance of a event object from a JSON object using a Decoder object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(EventType.self, forKey: .eventType)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        note = try container.decode(String.self, forKey: .note)
        id = try container.decode(String.self, forKey: .id)
    }
    enum EventType: String, Identifiable, CaseIterable, Encodable, Decodable {
        // Enumeration cases representing different event types
        case school, work, home, social, sport, unspecified
        var id: String {
            self.rawValue // Computed property that returns the rawValue (String) of the enum as the unique identifier
        }
        
        // Computed property that returns an emoji icon based on the enum case
        var icon: String {
            switch self {
            case .unspecified:
                return "??"
            case .school:
                return "??"
            case .work:
                return "??"
            case .home:
                return "??"
            case .social:
                return "??"
            case .sport:
                return "??"
            }
        }
    }
    
    var eventType: EventType // Type of event (e.g. school, work, home, etc.)
    var startDate: Date // Start date of the event
    var endDate: Date // End date of the event
    var note: String // Note or description of the event
    var id: String // Unique identifier for the event
    
    // Computed property to get the date components (month, day, year, hour, minute) of the start date
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: startDate)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
    // Computed property to get the date components (month, day, year, hour, minute) of the end date
    var endDateComponents: DateComponents {
        var endDateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: endDate)
        endDateComponents.timeZone = TimeZone.current
        endDateComponents.calendar = Calendar(identifier: .gregorian)
        return endDateComponents
    }
    
    // Initialize an Event instance with optional parameters, including default values
    init(id: String = UUID().uuidString, eventType: EventType = .unspecified, startDate: Date, endDate: Date, note: String) {
        self.eventType = eventType
        self.startDate = startDate
        self.endDate = endDate
        self.note = note
        self.id = id
    }
    
    // Data to be used in the preview events
    /* static var sampleEvents: [Event] {
     let viewModel = ViewModel() // create an instance of ViewModel
     let events = viewModel.courses.map { Course in
     return Event(startDate: Date().diff(numDays: -4), endDate: Date().diff(numDays: -4), note: Course.Days)
     }
     print(events)
     return(events)
     }*/
}

